class MyApp < Sinatra::Base
  set :public, File.dirname(__FILE__) + '/public'
  set :views, File.dirname(__FILE__) + '/templates'

  before do
    redirect "http://desconf.com.br" if heroku_host?
  end

  def heroku_host?
    request.host.match(/heroku/)
  end

  get '/' do
    emails = {
      'barbara' => "barbara@quavio.com.br",
      'daniel'  => "dwildt@gmail.com",
      'felipe'  => "felipe.benites@gmail.com",
      'natalia' => "nataliarsand@gmail.com",
      'pedro'   => "pedrobelleza@gmail.com",
      'rafael'  => "rafaelbandeira3@gmail.com",
      'mauricio' => "m@bitbonsai.com"
    }.each_pair { |k, v| v.replace(Digest::MD5.hexdigest(v)) }

    gravatar = lambda { |name| "http://www.gravatar.com/avatar/#{emails[name]}" }

    people = [
      {
        href: "http://twitter.com/barbaracones",
        name: "Barbara Wolff Dick",
        gravatar: gravatar['barbara']
      },
      {
        href: "http://twitter.com/dwildt",
        name: "Daniel Wildt",
        gravatar: gravatar['daniel']
      },
      {
        href: "http://twitter.com/felipebcabral",
        name: "Felipe Cabral",
        gravatar: gravatar['felipe']
      },
      {
        href: "http://twitter.com/nataliarsand",
        name: "Natalia Arsand",
        gravatar: gravatar['natalia']
      },
      {
        href: "http://twitter.com/bitbonsai",
        name: "Mauricio Wolff",
        gravatar: gravatar['mauricio']
      },
      {
        href: "http://twitter.com/pedrobelleza",
        name: "Pedro Belleza",
        gravatar: gravatar['pedro']
      },
      {
        href: "http://twitter.com/rafb3",
        name: "Rafael Bandeira",
        gravatar: gravatar['rafael']
      }
    ]
    slim :index, :locals => { :people => people }
  end

  get '/css/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :"sass/#{params['name']}", Compass.sass_engine_options
  end

  post '/' do
    s = Subscriber.create({
      :name => params[:name],
      :email => params[:mail],
      :created_at => Time.now
    })
    
    redirect "/"
  end
end
