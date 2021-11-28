using System.Data.SqlClient;

const string connectionString = "Server=localhost;Database=veles;Integrated Security=SSPI";
const string truncSQL = "TRUNCATE TABLE dbo.Docs";
const string insertSQL = "INSERT INTO dbo.Docs ([Id], [DateTime], [Number], [Client_Id], [Value]) VALUES (@id, @date, @number, @client, @val)";

using (SqlConnection connection = new SqlConnection(connectionString))
{    
    await connection.OpenAsync();

    SqlCommand truncate = new SqlCommand(truncSQL, connection);
    await truncate.ExecuteNonQueryAsync();

    Random rnd = new Random();

    for (var i = 1; i < 100000; i++) {
        SqlCommand insert = new SqlCommand(insertSQL, connection);
        insert.Parameters.AddWithValue("id", i);
        insert.Parameters.AddWithValue("date", RandomDate(rnd));
        insert.Parameters.AddWithValue("number", Guid.NewGuid().ToString("N"));
        insert.Parameters.AddWithValue("client", (int)rnd.NextInt64(1, 30));
        insert.Parameters.AddWithValue("val", rnd.NextSingle() * 1000.0f - 500.0f);

        await insert.ExecuteNonQueryAsync();
    }
}

using (SqlConnection connection = new SqlConnection(connectionString))
{
    await connection.OpenAsync();

    SqlCommand truncateTran = new SqlCommand("TRUNCATE TABLE dbo.[Transactions]", connection);
    await truncateTran.ExecuteNonQueryAsync();

    SqlCommand truncateAcc = new SqlCommand("DELETE FROM dbo.[Accounts]", connection);
    await truncateAcc.ExecuteNonQueryAsync();

    for (var i = 1; i <= 1000; i++)
    {
        SqlCommand insert = new SqlCommand("INSERT INTO dbo.[Accounts] ([Account_Id], [Name]) VALUES (@id, @name)", connection);
        insert.Parameters.AddWithValue("id", i);
        insert.Parameters.AddWithValue("name", $"Имя {i}");
        await insert.ExecuteNonQueryAsync();
    }

    Random rnd = new Random();
    for (var i = 1; i <= 10000000; i++)
    {
        SqlCommand insert = new SqlCommand("INSERT INTO dbo.[Transactions] ([Transaction_Id], [Account_Id], [Date], [Value]) VALUES (@id, @aid, @date, @val)", connection);
        insert.Parameters.AddWithValue("id", i);
        insert.Parameters.AddWithValue("aid", (int)rnd.NextInt64(1, 1001));
        insert.Parameters.AddWithValue("date", RandomDate(rnd));
        insert.Parameters.AddWithValue("val", rnd.NextSingle() * 1000.0f);
        await insert.ExecuteNonQueryAsync();

        if(i % 500000 == 0)
        {
            Console.WriteLine($"Inserting {i}");
        }
    }
}


static DateTime RandomDate(Random rnd)
{
    return new DateTime(
        (int)rnd.NextInt64(2008, 2021),
        (int)rnd.NextInt64(1, 13),
        (int)rnd.NextInt64(1, 29),
        (int)rnd.NextInt64(0, 24),
        (int)rnd.NextInt64(0, 60),
        (int)rnd.NextInt64(0, 60)
    );
}