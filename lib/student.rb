require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
      @id = id
      @name = name
      @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL

      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      # insert the student
      DB[:conn].execute(sql, self.name, self.grade)

      # get the student ID from the database and save it to the Ruby instance
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

      # return the ruby instance
      self
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end


end
