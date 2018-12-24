require 'pry'

class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name,grade,id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  #crafts a SQL statement to create a Students table and give that table
  #column names that match the attributes of an individual Students instance
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
    DB[:conn].execute(sql)
  end
#binding.pry

  #drops the Students table
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end

  #saves a given instance of this Student class into the Students table of database
  def save
    sql = <<-SQL
      INSERT INTO students (name,grade)
      VALUES (?,?)
    SQL

    DB[:conn].execute(sql,name,grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:,grade:)
    student = Student.new(name,grade)
    student.save
    student
  end
end
