# Este archivo deberia llamarse Main.rb
# El controlador delega tareas, deriva. Menos logica en el controller mas logica en el modelo. La aplicacion vive en el modelo.
# Siempre hay que levantar antes la BD de MongoDB ejecutando este comando en consola (puede ser la consola de visual studio code, directamente desde donde estoy parado):
# "c:\Program Files\MongoDB\Server\3.4\bin\mongod.exe" --dbpath "C:\Projects\Mongo"
# Para ejecutar levantar la consola de ruby. Buscar en windows "Start Command Prompt with Ruby".
# Levanto el server con "ruby controller.rb" ejecutandolo desde C:\Projects\Curso Web Programming.
# Abrir en el browser http://localhost:4567/
# Crtl+C tiro abajo el server.


# Este archivo seria el controller.

# require solo requiere gemas. require_relative requiere archivos. 
require 'sinatra'
require 'mongoid'
require_relative 'air_conditioner'
require_relative 'employee'
require_relative 'electoral_college'
require 'sinatra/reloader'

enable :sessions
air_conditioner = AirConditioner.new
# Archivo de configuracion de Mongo.
Mongoid.load!("mongoid.yml")
# Esto se usaba antes de implementar Mongo para contar los votos.
votes = Array.new


get '/' do
  @welcome_message = "People at the office is fighting about the air conditioner temperature, " \
         "some want the air conditioner to be turned off and some want it very cold. " \
         "Lets solve this problem democratically by creating and application were they " \
         "can vote the desired AC temperature."
    # Guardamos el valor de session en una variable y lo pasamos a la vista. Es solo para el ejemplo de /guardarvalor/:value.
    @sessionvalue = session['value']
# Las variables de instancia se pueden usar en la vista. Para eso se les agrega una @.
# Request es un objeto de Sinatra. Guarda todo lo que viene en el request y se puede utilizar
    @request_ip = request.ip
    @request_port = request.port
    # Esto se usaba para mostrar el total de votes antes de implementar Mongo.
    # @current_votes = votes.size
    # Employee puede usar los metodos .all y .size porque implementa Mongo.
    @current_votes = Employee.all.size()
    # El ||= es un Or, si hay algo lo asigna, sino lo deja vacio.
    @last_employee_name ||= session['last_employee_name']
    @last_employee_category ||= session['last_employee_category']
    @last_employee_temperature ||= session['last_employee_temperature']
    @notice ||= session['notice']
    session['notice'] = nil
    erb :index
end

# Aca usamos esto para guardar un valor en la session. Guardamos un valor que le pasamos por url, pero en realidad es
# por login, cuando un usuario se loguea.
get '/guardarvalor/:value' do
    session['value'] = params['value']
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
#   Antes de implementar MongoDB guardabamos los datos asi. En el Array votes.
#    employee = Employee.new
#    employee.name = params[:name]
#    employee.category = params[:category]
#    employee.desired_AC_temperature = params[:temperature].to_i
#    votes.push(employee)

  Employee.create(
	name: params[:name],
	category: params[:category],
    desired_AC_temperature: params[:temperature].to_i)

    session['last_employee_name'] = params[:name]
    session['last_employee_category'] = params[:category]
    session['last_employee_temperature'] = params[:temperature]
    session['notice'] = "Employee Voted Successfully!"
    redirect '/'
    # Esto estaba porque al votar antes redireccionaba a otra pagina con un mensaje.
    #erb :thanks_for_voting
end

# Esto es para ser consumido por otra aplicacion que quiera tener todos los votos. Es la API.
get '/votes.json' do
  content_type :json
  Employee.all.to_json
end

post '/calculate_votes' do
    ec = ElectoralCollege.new
    @result = ec.calculate_winning_temperature(Employee.all)
    erb :calculates_votes
end

get '/css/css' do
    erb :'css/css'
end

get '/css/csslayout' do
    erb :'css/csslayout'
end

get '/css/csshtml5' do
    erb :'css/csshtml5'
end

get '/bootstrap/html5' do
    erb :'/bootstrap/html5'
end