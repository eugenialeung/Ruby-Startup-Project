require "employee"

class Startup

    attr_reader :name, :funding, :salaries, :employees

    def initialize(name, funding, salaries)
        # Below are attributes
        @name = name
        @funding = funding
        @salaries = salaries
        @employees = []
    end

    def valid_title?(title)
        @salaries.has_key?(title)
    end

    def >(other_startup)
        self.funding > other_startup.funding
    end

    def hire(employee_name, title)
        if self.valid_title?(title)
            @employees << Employee.new(employee_name, title)
        else
            raise "Title is invalid!"
        end
    end

    def size
        @employees.length
    end

    def pay_employee(employee)
        money_owed = @salaries[employee.title]
        if @funding >= money_owed
            employee.pay(money_owed)
            @funding -= money_owed
        else 
            raise "Not enough funding!"
        end
    end
    
    def payday
        @employees.each do |employee|
            self.pay_employee(employee)
        end
    end

    def average_salary
        sum = 0
        @employees.each do |employee|
            sum += @salaries[employee.title]
        end
        sum / (@employees.length * 1.0)
    end

    def close
        @employees = []
        @funding = 0
    end

    # startup is the one acquiring the current business
    def acquire(startup)
        # self.funding is a getter so we don't use self.funding in this case
        @funding += startup.funding
        startup.salaries.each do |title, amount|
            # does our current salary(@salaries) have the new acquiring startup titles(title)?
            if !@salaries.has_key?(title)
                @salaries[title] = amount
            end
        end
        # Hire employees
        @employees += startup.employees 

        # Close our current business
        startup.close()
    end
end
