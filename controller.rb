# Este archivo deberia llamarse Main.rb
# El controlador delega tareas, deriva. Menos logica en el controller mas logica en el modelo.
# Para ejecutar levantar la consola de ruby. Buscar en windows "Start Command Prompt with Ruby".
# Levanto el server con "ruby hi.rb".
# Crtl+C tiro abajo el server.

# Este archivo seria el controller.

# require solo requiere gemas. require_relative requiere archivos. 
require 'sinatra'
require_relative 'air_conditioner'
require_relative 'employee'
require_relative 'electoral_college'
require 'sinatra/reloader'

air_conditioner = AirConditioner.new
votes = Array.new


get '/' do
# Las variables de instancia se pueden usar en la vista. Para eso se les agrega una @.
    @request_ip = request.ip
    @request_port = request.port
    @current_votes = votes.size
    erb :index
#    return "<h1> ---Welcome Page--- </h1><br>" +
#            "<h2> Your IP is: #{request.ip} </h2>" +
#            "<h2> Your PORT is: #{request.port} </h2>"
            # request es un objeto de Sinatra. Guarda todo lo que viene en el request y se puede utilizar.
end

get '/hi' do
    return "Hello World!"
end

get '/ac/status' do
    message = "The air conditioner is "
    if air_conditioner.status == 'ON'
        message << "ON with a temperature of #{air_conditioner.temperature.to_s}"
    else
        message << "OFF."
    end
    return message
end

get '/ac/turn_on' do
    air_conditioner.turn_on
end

get '/ac/turn_off' do
    air_conditioner.turn_off
end

get '/hello/:name' do
    # matches "GET /hello/foo" and "GET /hello/bar"
    # params['name'] is 'foo' or 'bar'
    # params es un array que da Sinatra. Contiene todos los parametros que vienen en un request (siempre lo del ultimo)
    "Hello #{params['name']}!"
end

post '/votes' do
    employee = Employee.new
    employee.name = params[:name]
    employee.category = params[:category]
    employee.desired_AC_temperature = params[:temperature].to_i
    votes.push(employee)
    erb :thanks_for_voting
end

post '/calculate_votes' do
    ec = ElectoralCollege.new
    @result = ec.calculate_winning_temperature(votes)
    erb :calculates_votes
end

post '/back' do
    erb :index
end