# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# A note on subqueries: we can refer to values in the outer SELECT within the
# inner SELECT. We can name the tables so that we can tell the difference
# between the inner and outer versions.

def example_select_with_subquery
  execute(<<-SQL)
    SELECT
      name
    FROM
      countries
    WHERE
      population > (
        SELECT
          population
        FROM
          countries
        WHERE
          name='Romania'
        )
  SQL
end

def larger_than_russia
  # List each country name where the population is larger than 'Russia'.
  execute(<<-SQL)
  select countries.name
  from countries
  where countries.population > (
    select countries.population
    from countries
    where countries.name = 'Russia'
  )
  SQL
end

def richer_than_england
  # Show the countries in Europe with a per capita GDP greater than
  # 'United Kingdom'.
  execute(<<-SQL)
  select countries.name
  from countries
  where countries.continent = 'Europe' and countries.gdp/countries.population > (
    select countries.gdp/countries.population
    from countries
    where countries.name = 'United Kingdom'
  )
  SQL
end

def neighbors_of_certain_b_countries
  # List the name and continent of countries in the continents containing
  # 'Belize', 'Belgium'.
  execute(<<-SQL)
  select countries.name, countries.continent
  from countries
  where countries.continent in (
    select countries.continent
    from countries
    where countries.name in ('Belize', 'Belgium')
  )
  SQL
end

def population_constraint
  # Which country has a population that is more than Canada but less than
  # Poland? Show the name and the population.
  execute(<<-SQL)
  select countries.name, countries.population
  from countries
  where countries.population > (
    select countries.population
    from countries
    where countries.name ='Canada'
  ) and countries.population < (
    select countries.population
    from countries
    where countries.name ='Poland'
  )
  SQL
end

def sparse_continents
  # Find every country that belongs to a continent where each country's
  # population is less than 25,000,000. Show name, continent and
  # population.
  # Hint: Sometimes rewording the problem can help you see the solution.
  execute(<<-SQL)
  select countries.name, countries.continent, countries.population
  from countries
  where countries.continent NOT IN (
    select countries.continent
    from countries
    where countries.population > 25000000
  )
  SQL
end
