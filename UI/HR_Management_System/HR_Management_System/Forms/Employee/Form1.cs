using System;
using System.Data;
using System.Windows.Forms;
using Npgsql; // PostgreSQL Library

namespace HR_Management_System
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        // ==========================================
        // 1. DATABASE CONNECTION STRING
        // IMPORTANT: Replace 'YOUR_PASSWORD' with your actual PostgreSQL password.
        // ==========================================
        NpgsqlConnection connect = new NpgsqlConnection("server=localHost;port=5432;user Id=postgres;password=123456;database=hr_personnel_db");


        // ==========================================
        // 2. LIST BUTTON (READ)
        // ==========================================
        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                connect.Open();

                // SQL Query to select all employees
                string query = "SELECT * FROM \"Employee\" ORDER BY \"EmployeeID\" ASC";

                // Data Adapter: Acts as a bridge between Database and App
                NpgsqlDataAdapter da = new NpgsqlDataAdapter(query, connect);

                // DataSet: In-memory cache of data
                DataSet ds = new DataSet();
                da.Fill(ds);

                // Bind data to the grid view
                dataGridView1.DataSource = ds.Tables[0];

                connect.Close();
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
            try
            {
                connect.Open();

                // Parameterized SQL Query (Secure way)
                string query = "INSERT INTO \"Employee\" (\"FirstName\", \"LastName\", \"Email\", \"Phone\", \"DepartmentID\") " +
                               "VALUES (@fname, @lname, @email, @phone, @deptId)";

                NpgsqlCommand cmd = new NpgsqlCommand(query, connect);

                // Assign values from TextBoxes to Parameters
                cmd.Parameters.AddWithValue("@fname", textBox1.Text);
                cmd.Parameters.AddWithValue("@lname", textBox2.Text);
                cmd.Parameters.AddWithValue("@email", textBox3.Text);
                cmd.Parameters.AddWithValue("@phone", textBox4.Text);

                // Convert Department ID to integer
                cmd.Parameters.AddWithValue("@deptId", int.Parse(textBox5.Text));

                cmd.ExecuteNonQuery(); // Execute the command
                connect.Close();

                MessageBox.Show("New employee added successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);

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
            // Ensure row index is valid (header row is -1)
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dataGridView1.Rows[e.RowIndex];

                // Fill TextBoxes with data from the selected row
                textBox1.Text = row.Cells["FirstName"].Value.ToString();
                textBox2.Text = row.Cells["LastName"].Value.ToString();
                textBox3.Text = row.Cells["Email"].Value.ToString();
                textBox4.Text = row.Cells["Phone"].Value.ToString();
                textBox5.Text = row.Cells["DepartmentID"].Value.ToString();

                // IMPORTANT: Store the ID in a hidden tag (e.g., inside the Update button)
                // We need this ID to know WHO to Update or Delete.
                button3.Tag = row.Cells["EmployeeID"].Value;
            }
        }

        // ==========================================
        // 5. UPDATE BUTTON
        // ==========================================
        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                connect.Open();

                // SQL Update Query
                string query = "UPDATE \"Employee\" SET \"FirstName\"=@fname, \"LastName\"=@lname, \"Email\"=@email, \"Phone\"=@phone, \"DepartmentID\"=@deptId " +
                               "WHERE \"EmployeeID\"=@id";

                NpgsqlCommand cmd = new NpgsqlCommand(query, connect);

                cmd.Parameters.AddWithValue("@fname", textBox1.Text);
                cmd.Parameters.AddWithValue("@lname", textBox2.Text);
                cmd.Parameters.AddWithValue("@email", textBox3.Text);
                cmd.Parameters.AddWithValue("@phone", textBox4.Text);
                cmd.Parameters.AddWithValue("@deptId", int.Parse(textBox5.Text));

                // Retrieve the stored ID from the Tag
                cmd.Parameters.AddWithValue("@id", Convert.ToInt32(button3.Tag));

                cmd.ExecuteNonQuery();
                connect.Close();

                MessageBox.Show("Employee updated successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
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
                    button1.PerformClick(); // Refresh list
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
                connect.Close();
            }
        }

    }
}