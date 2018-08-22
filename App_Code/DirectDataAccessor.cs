using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Text;
	/// <summary>
	/// 数据库操作
	/// </summary>
	public static class DirectDataAccessor
	{
		private static string ConnectString = "";

		static DirectDataAccessor()
		{
			ConnectString = ConfigurationManager.AppSettings["connectionString"];
		}

		static int connectionCount = 0;
		
		public static int ConnectionCount() 
		{
			return connectionCount;
		}
		
		private static string GetConnectString()
		{
			return ConnectString;
		}
		
		/// <summary>
        /// 执行一条SQL语句,如果失败则返回-1
		/// </summary>
		/// <param name="ExecuteSQL">Sql语句</param>
		/// <returns>返回本次执行影响的行数，如果失败则返回-1</returns>
		public static int Execute(string ExecuteSQL)
		{
			SqlCommand dsCommand = GetConnection(ExecuteSQL);
			dsCommand.Connection.Open();			
			
			SqlTransaction myTrans = dsCommand.Connection.BeginTransaction();	
			try 
			{			
				dsCommand.Transaction = myTrans;
				int InfectionRows = dsCommand.ExecuteNonQuery();
				myTrans.Commit();
				dsCommand.Connection.Close();
				return InfectionRows;
			}
			catch(Exception   ex) 
			{
				myTrans.Rollback();
				dsCommand.Connection.Close();
				//return -1;
                throw ex;
			}
			finally 
			{
				dsCommand.Connection.Close();
				dsCommand.Connection.Dispose();
				dsCommand.Dispose();
			}
		}

		private static SqlCommand GetConnection(string SQL) 
		{
			SqlCommand dsCommand = new SqlCommand();
			dsCommand.Connection =  new SqlConnection(GetConnectString());
			dsCommand.CommandType = CommandType.Text;
			dsCommand.CommandText = SQL;
			dsCommand.CommandTimeout = 120;
			dsCommand.Connection.StateChange += new StateChangeEventHandler(WhenStateChanged);
			return dsCommand;
		}

		private static void WhenStateChanged(object sender, StateChangeEventArgs args) 
		{
			if (args.CurrentState == ConnectionState.Closed) 
			{
				connectionCount--;
			}
			if (args.CurrentState == ConnectionState.Open) 
			{
				connectionCount++;
			}
		}

		public static DataSet QueryForDataSet(string QuerySQL) 
		{
			SqlCommand dsCommand = GetConnection(QuerySQL);
			SqlDataAdapter dataAdapter= new SqlDataAdapter();
			dataAdapter.SelectCommand =dsCommand;
			DataSet ds = new DataSet();
			dataAdapter.Fill(ds);
			dsCommand.Connection.Close();
			dsCommand.Connection.Dispose();
			dsCommand.Dispose();
			return ds;
		}
		
		public static DataSet QueryForDataSet(string QuerySQL,string TableName) 
		{
			SqlCommand dsCommand = GetConnection(QuerySQL);
			SqlDataAdapter dataAdapter= new SqlDataAdapter();
			dataAdapter.SelectCommand =dsCommand;
			DataSet ds = new DataSet();
			dataAdapter.Fill(ds,TableName);
			dsCommand.Connection.Close();
			dsCommand.Connection.Dispose();
			dsCommand.Dispose();
			return ds;
		}

		public static DataView QueryForDataView(string QuerySQL,string TableName) 
		{
			DataSet ds = QueryForDataSet(QuerySQL,TableName);
			DataView dv = new DataView(ds.Tables[TableName]);
			return dv;
		}

		public static SqlDataAdapter QueryForDataAdapter(string QuerySQL) 
		{
			SqlCommand dsCommand = GetConnection(QuerySQL);
			SqlDataAdapter dataAdapter= new SqlDataAdapter();
			dataAdapter.SelectCommand =dsCommand;
			return dataAdapter;
		}
        /// <summary>
        /// 记录日志
        /// </summary>
        /// <param name="container">文件夹名称</param>
        /// <param name="logname">日志名称</param>
        /// <param name="logcontent">日志内容</param>
        public static void writeLog(string container, string logname, string logcontent)
        {
            try
            {

                string path = System.Web.HttpContext.Current.Server.MapPath("~")+@"\log";
                if (!System.IO.Directory.Exists(path + @"\" + container))
                {
                    System.IO.Directory.CreateDirectory(path + @"\" + container);
                }
                //文件完整路径
                path += @"\" + container + @"\" + logname + DateTime.Now.ToString("yyyy-MM-dd") + ".log";
                StreamWriter sw = new StreamWriter(path, true, Encoding.Default);
                sw.WriteLine(DateTime.Now.ToString() + "\r\n" + logcontent);
                sw.Close();
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return;
            }
        }
        /// <summary>
        /// 带参数的获取数据集
        /// </summary>
        /// <param name="QuerySQL">sql语句</param>
        /// <param name="commandParas">sql语句参数数组</param>
        /// <returns></returns>
        public static DataSet QueryForDataSet(string QuerySQL, params SqlParameter[] commandParas)
        {
            SqlCommand dsCommand = GetConnection(QuerySQL);
            if (commandParas != null)
            {
                foreach (SqlParameter p in commandParas)
                {
                    if (p != null)
                    {
                        // 检查未分配值的输出参数,将其分配以DBNull.Value. 
                        if ((p.Direction == ParameterDirection.InputOutput || p.Direction == ParameterDirection.Input) &&
                            (p.Value == null))
                        {
                            p.Value = DBNull.Value;
                        }
                        dsCommand.Parameters.Add(p);
                    }
                }
            }
            // 创建 DataAdapter & DataSet 
            using (SqlDataAdapter da = new SqlDataAdapter(dsCommand))
            {
                DataSet ds = new DataSet();
                da.Fill(ds);
                dsCommand.Parameters.Clear();
                dsCommand.Connection.Close();
                dsCommand.Connection.Dispose();
                dsCommand.Dispose();
                return ds;
            }
        }

	}
