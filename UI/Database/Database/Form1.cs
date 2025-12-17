using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Database
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            LoadDepartments();
            LoadEmployeeTypes();
        }

        // ==========================================
        // 1. DATABASE CONNECTION STRING
        // IMPORTANT: Replace 'YOUR_PASSWORD' with your actual PostgreSQL password.
        // ==========================================
        NpgsqlConnection connect = new NpgsqlConnection("server=localHost;port=5432;user Id=postgres;password=Fener1907;database=deneme2");


        // ==========================================
        // 2. LIST BUTTON (READ)
        // ==========================================
        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                connect.Open();

                // SQL Query to select all employees
                string query = @"
                SELECT 
                    e.""EmployeeID"",
                    e.""FirstName"",
                    e.""LastName"",
                    e.""Email"",
                    e.""Phone"",
                    d.""DepartmentName"",
                    e.""EmployeeType"",
                    e.""DepartmentID"",
                    s.""BaseSalary"",
                    s.""BonusAmount"",
                    s.""NetSalary""
                FROM ""Employee"" e
                LEFT JOIN ""Department"" d
                    ON e.""DepartmentID"" = d.""DepartmentID""
                LEFT JOIN LATERAL (
                    SELECT *
                    FROM ""Salary"" s
                    WHERE s.""EmployeeID"" = e.""EmployeeID""
                    ORDER BY s.""Year"" DESC,s.""Month"" DESC
                    LIMIT 1
                ) s ON true
                ORDER BY e.""EmployeeID"";
                ";

                // Data Adapter: Acts as a bridge between Database and App
                NpgsqlDataAdapter da = new NpgsqlDataAdapter(query, connect);

                // DataSet: In-memory cache of data
                DataSet ds = new DataSet();
                da.Fill(ds);

                // Bind data to the grid view
                dataGridView1.DataSource = ds.Tables[0];
                dataGridView1.Columns["DepartmentID"].Visible = false;

                dataGridView1.Columns["DepartmentName"].HeaderText = "Department";
                dataGridView1.Columns["EmployeeType"].HeaderText = "Employee Type";

                connect.Close();
                ClearForm();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
                connect.Close();
            }
        }


        // ==========================================
        // 3. ADD BUTTON (CREATE)
        // ==========================================
        private void button2_Click(object sender, EventArgs e)
        {
            if (
                string.IsNullOrWhiteSpace(textBox1.Text) || // FirstName
                string.IsNullOrWhiteSpace(textBox2.Text) || // LastName
                string.IsNullOrWhiteSpace(textBox3.Text) || // Email
                string.IsNullOrWhiteSpace(textBox4.Text) || // Phone
                cmbDepartment.SelectedValue == null ||
                string.IsNullOrWhiteSpace(txtBaseSalary.Text)
            )
            {
                MessageBox.Show(
                    "All fields are required.",
                    "Validation Error",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return;
            }
            if (!decimal.TryParse(txtBaseSalary.Text, out decimal baseSalary))
            {
                MessageBox.Show("Base Salary must be a valid number.");
                return;
            }

            try
            {
                connect.Open();

                // Parameterized SQL Query (Secure way)
                string query = "INSERT INTO \"Employee\" (\"FirstName\", \"LastName\", \"Email\", \"Phone\", \"DepartmentID\",\"EmployeeType\") " +
                               "VALUES (@fname, @lname, @email, @phone, @deptId,@empType) " +
                               "RETURNING \"EmployeeID\";";

                NpgsqlCommand cmd = new NpgsqlCommand(query, connect);

                // Assign values from TextBoxes to Parameters
                cmd.Parameters.AddWithValue("@fname", textBox1.Text);
                cmd.Parameters.AddWithValue("@lname", textBox2.Text);
                cmd.Parameters.AddWithValue("@email", textBox3.Text);
                cmd.Parameters.AddWithValue("@phone", textBox4.Text);
                cmd.Parameters.AddWithValue("@empType", cmbEmployeeType.SelectedItem.ToString());

                // Convert Department ID to integer
                cmd.Parameters.AddWithValue("@deptId", (int)cmbDepartment.SelectedValue);

                int newEmployeeId =Convert.ToInt32(cmd.ExecuteScalar());
                string salQuery = "INSERT INTO \"Salary\" (\"EmployeeID\", \"Month\", \"Year\", \"BaseSalary\") " +
                                  "VALUES (@empId, @month, @year, @baseSalary) " +
                                  "RETURNING \"BonusAmount\",\"NetSalary\";";
                NpgsqlCommand salCmd = new NpgsqlCommand(salQuery, connect);
                salCmd.Parameters.AddWithValue("@empId", newEmployeeId);
                salCmd.Parameters.AddWithValue("@month", DateTime.Now.Month);
                salCmd.Parameters.AddWithValue("@year",DateTime.Now.Year);
                salCmd.Parameters.AddWithValue("@baseSalary",baseSalary);
                using(var reader = salCmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtBonus.Text = reader["BonusAmount"].ToString();
                        txtNetSalary.Text = reader["NetSalary"].ToString();
                    }
                }
                connect.Close();
                button1.PerformClick();

                foreach (DataGridViewRow row in dataGridView1.Rows)
                {
                    if (!row.IsNewRow &&
                        Convert.ToInt32(row.Cells["EmployeeID"].Value) == newEmployeeId)
                    {
                        dataGridView1.ClearSelection();
                        row.Selected = true;

                        button3.Tag = newEmployeeId;
                        LoadSalary(newEmployeeId);
                        break;
                    }
                }

                MessageBox.Show("Employee and salary added successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearForm();

                // Auto-refresh the list
                button1.PerformClick();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
                connect.Close();
            }    
        }

        // ==========================================
        // 4. CELL CLICK EVENT (MEMORY)
        // Populate textboxes when a row is clicked
        // ==========================================
        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            // Header veya boş satıra tıklanırsa çık
            if (e.RowIndex < 0) return;

            DataGridViewRow row = dataGridView1.Rows[e.RowIndex];

            // Boş satır kontrolü (YENİ KAYIT SATIRI)
            if (row.IsNewRow)
            {
                ClearForm();
                return;
            }

            textBox1.Text = row.Cells["FirstName"].Value?.ToString();
            textBox2.Text = row.Cells["LastName"].Value?.ToString();
            textBox3.Text = row.Cells["Email"].Value?.ToString();
            textBox4.Text = row.Cells["Phone"].Value?.ToString();

            // DepartmentID NULL mu kontrol et
            if (row.Cells["DepartmentID"].Value != DBNull.Value)
            {
                cmbDepartment.SelectedValue =
                    Convert.ToInt32(row.Cells["DepartmentID"].Value);
                cmbEmployeeType.SelectedItem = row.Cells["EmployeeType"].Value.ToString();
            }
            int empId = Convert.ToInt32(row.Cells["EmployeeID"].Value);
            button3.Tag = empId;

            LoadSalary(empId);
        }

        // ==========================================
        // 5. UPDATE BUTTON
        // ==========================================
        private void button3_Click(object sender, EventArgs e)
        {
            if (button3.Tag == null)
            {
                MessageBox.Show("Please select an employee first.");
                return;
            }

            if(!decimal.TryParse(txtBaseSalary.Text, out decimal baseSalary))
            {
                MessageBox.Show("Base Salary must be a valid number.");
                return;
            }

            try
            {
                connect.Open();

                // SQL Update Query
                string query = "UPDATE \"Employee\" SET \"FirstName\"=@fname, \"LastName\"=@lname, \"Email\"=@email, \"Phone\"=@phone, \"DepartmentID\"=@deptId, \"EmployeeType\"=@empType " +
                               "WHERE \"EmployeeID\"=@id";

                NpgsqlCommand cmd = new NpgsqlCommand(query, connect);

                cmd.Parameters.AddWithValue("@fname", textBox1.Text);
                cmd.Parameters.AddWithValue("@lname", textBox2.Text);
                cmd.Parameters.AddWithValue("@email", textBox3.Text);
                cmd.Parameters.AddWithValue("@phone", textBox4.Text);
                cmd.Parameters.AddWithValue("@deptId", (int)cmbDepartment.SelectedValue);
                cmd.Parameters.AddWithValue("@empType", cmbEmployeeType.SelectedItem.ToString());

                // Retrieve the stored ID from the Tag
                cmd.Parameters.AddWithValue("@id", Convert.ToInt32(button3.Tag));

                cmd.ExecuteNonQuery();

                string checkQuery = @"
                                    SELECT COUNT(*)
                                    FROM ""Salary""
                                    WHERE ""EmployeeID"" = @empId
                                    AND ""Year"" = @year
                                    AND ""Month"" = @month;";
                NpgsqlCommand checkCmd = new NpgsqlCommand(checkQuery, connect);
                checkCmd.Parameters.AddWithValue("@empId", Convert.ToInt32(button3.Tag));
                checkCmd.Parameters.AddWithValue("@year", DateTime.Now.Year);
                checkCmd.Parameters.AddWithValue("@month", DateTime.Now.Month);

                int salaryExists = Convert.ToInt32(checkCmd.ExecuteScalar());
                if (salaryExists == 0)
                {
                    string insertSalary = @"
                                            INSERT INTO ""Salary""
                                            (""EmployeeID"", ""Month"", ""Year"", ""BaseSalary"")
                                            VALUES (@empId, @month, @year, @baseSalary);";

                    NpgsqlCommand insCmd = new NpgsqlCommand(insertSalary, connect);
                    insCmd.Parameters.AddWithValue("@empId", Convert.ToInt32(button3.Tag));
                    insCmd.Parameters.AddWithValue("@month", DateTime.Now.Month);
                    insCmd.Parameters.AddWithValue("@year", DateTime.Now.Year);
                    insCmd.Parameters.AddWithValue("@baseSalary", baseSalary);

                    insCmd.ExecuteNonQuery();
                }
                else
                {
                    string salUpdate = @"
                                        UPDATE ""Salary""
                                        SET ""BaseSalary"" = @baseSalary
                                        WHERE ""EmployeeID"" = @empId
                                        AND ""Year"" = @year
                                        AND ""Month"" = @month;";

                    NpgsqlCommand salCmd = new NpgsqlCommand(salUpdate, connect);
                    salCmd.Parameters.AddWithValue("@baseSalary", baseSalary);
                    salCmd.Parameters.AddWithValue("@empId", Convert.ToInt32(button3.Tag));
                    salCmd.Parameters.AddWithValue("@year", DateTime.Now.Year);
                    salCmd.Parameters.AddWithValue("@month", DateTime.Now.Month);

                    salCmd.ExecuteNonQuery();
                }
                connect.Close();

                MessageBox.Show("Employee and salary updated successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                button1.PerformClick(); // Refresh list
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
                connect.Close();
            }
        }

        // ==========================================
        // 6. DELETE BUTTON
        // ==========================================
        private void button4_Click(object sender, EventArgs e)
        {
            try
            {
                // Confirmation Dialog
                DialogResult result = MessageBox.Show("Are you sure you want to delete this employee?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);

                if (result == DialogResult.Yes)
                {
                    connect.Open();

                    // SQL Delete Query
                    string query = "DELETE FROM \"Employee\" WHERE \"EmployeeID\"=@id";

                    NpgsqlCommand cmd = new NpgsqlCommand(query, connect);

                    // Retrieve the stored ID
                    cmd.Parameters.AddWithValue("@id", Convert.ToInt32(button3.Tag));

                    cmd.ExecuteNonQuery();
                    connect.Close();

                    MessageBox.Show("Employee deleted successfully.", "Deleted", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    ClearForm();
                    button1.PerformClick(); // Refresh list
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
                connect.Close();
            }
        }
        private void LoadDepartments()
        {
            try
            {
                connect.Open();

                string query = "SELECT \"DepartmentID\", \"DepartmentName\" FROM \"Department\" ORDER BY \"DepartmentName\"";
                NpgsqlDataAdapter da = new NpgsqlDataAdapter(query, connect);
                DataTable dt = new DataTable();
                da.Fill(dt);

                cmbDepartment.DisplayMember = "DepartmentName"; // Kullanıcıya görünen
                cmbDepartment.ValueMember = "DepartmentID";     // Arka planda tutulan
                cmbDepartment.DataSource = dt;

                connect.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Department load error: " + ex.Message);
                connect.Close();
            }
        }

        private void ClearForm()
        {
            textBox1.Clear();
            textBox2.Clear();
            textBox3.Clear();
            textBox4.Clear();
            txtBaseSalary.Clear();
            txtBonus.Clear();
            txtNetSalary.Clear();

            if(cmbDepartment.Items.Count > 0 ) {cmbDepartment.SelectedIndex = 0;}
            button3.Tag = null;
        }
        private void LoadSalary(int employeeId)
        {
            txtBaseSalary.Clear();
            txtBonus.Clear();
            txtNetSalary.Clear();

            string query = @"
                            SELECT ""BaseSalary"", ""BonusAmount"", ""NetSalary""
                            FROM ""Salary""
                            WHERE ""EmployeeID"" = @empId
                            ORDER BY ""Year"" DESC, ""Month"" DESC
                            LIMIT 1;";
            connect.Open();

            using (NpgsqlCommand cmd = new NpgsqlCommand(query, connect))
            {
                cmd.Parameters.AddWithValue("@empId", employeeId);

                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtBaseSalary.Text = reader["BaseSalary"].ToString();
                        txtBonus.Text = reader["BonusAmount"].ToString();
                        txtNetSalary.Text = reader["NetSalary"].ToString();
                    }
                }
            }
            connect.Close();
        }
        private void LoadEmployeeTypes()
        {
            cmbEmployeeType.Items.Clear();
            cmbEmployeeType.Items.Add("FULL_TIME");
            cmbEmployeeType.Items.Add("INTERN");
            cmbEmployeeType.SelectedIndex = 0; // default
        }



    }
}
