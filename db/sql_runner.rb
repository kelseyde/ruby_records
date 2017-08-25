require('pg')

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
