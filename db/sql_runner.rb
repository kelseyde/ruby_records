require('pg')

#SqlRunner class to interact with SQL from ruby

class SqlRunner

  def self.run( sql, values=[] )
    begin
      db = PG.connect({ dbname: 'ruby_records', host: 'localhost' })
      db.prepare("query", sql)
      result = db.exec_prepared( "query", values )
    ensure
      db.close
    end
    return result
  end

end

#Sql methods for CRUD actions

# module SqlMethods
#
#   def save
#     sql = "INSERT INTO #{self.class.to_s.downcase + "s"} (#{@@rows}) VALUES (#{@@prepared}) RETURNING id;"
#     values = @@values
#     result = SqlRunner.run(sql, values)
#     @id = result[0]["id"].to_i
#   end
#
# end
