# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

manager_user = User.new(name: 'temp_manager', email: 'temp_manager@bugzilla.com', user_type: 'manager',
                        password: 'qwerty', password_confirmation: 'qwerty')
manager_user.save
qa_user = User.new(name: 'temp_qa', email: 'temp_qa@bugzilla.com', user_type: 'qa', password: 'qwerty',
                   password_confirmation: 'qwerty')
qa_user.save
developer_user = User.new(name: 'temp_developer', email: 'temp_developerr@bugzilla.com', user_type: 'developer',
                          password: 'qwerty', password_confirmation: 'qwerty')
developer_user.save
