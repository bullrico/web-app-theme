class ThemeGenerator < Rails::Generator::Base
  
  default_options :app_name => 'Web App',
                  :layout_type => :administration,
                  :theme => :default,
                  :no_layout => false,
                  :erb => false,
                  :haml => false,
                  :list => false
    
  def initialize(runtime_args, runtime_options = {})
    super
    @name = @args.first || (options[:layout_type].to_s == "sign" ? "sign" : "application")
    list_themes if options[:list]
  end
  
  def manifest
    record do |m|            
      m.directory("app/views/layouts")
      if haml?
        m.directory("public/stylesheets/sass/web_app_theme/themes/")
        m.template("view_layout_#{options[:layout_type]}.html.haml", File.join("app/views/layouts", "#{@name}.html.haml")) unless options[:no_layout]
        m.template("../../../stylesheets/base.sass",  File.join("public/stylesheets/sass/web_app_theme/", "base.sass"))
        m.template("web_app_theme_override.sass",  File.join("public/stylesheets/sass/", "web_app_theme.sass"))
        m.template("../../../stylesheets/themes/#{options[:theme]}/style.sass",  File.join("public/stylesheets/sass/web_app_theme/themes/", "#{options[:theme]}.sass"))      
      else
        m.directory("public/stylesheets/themes/#{options[:theme]}/")
        m.template("view_layout_#{options[:layout_type]}.html.erb", File.join("app/views/layouts", "#{@name}.html.erb")) unless options[:no_layout]
        m.template("../../../stylesheets/base.css",  File.join("public/stylesheets", "web_app_theme.css"))
        m.template("web_app_theme_override.css",  File.join("public/stylesheets", "web_app_theme_override.css"))
        m.template("../../../stylesheets/themes/#{options[:theme]}/style.css",  File.join("public/stylesheets/themes/#{options[:theme]}", "style.css"))      
      end
    end
  end
  
  def banner
    "Usage: #{$0} theme [layout_name] [options]"
  end

protected

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--app_name=app_name", String, "") { |v| options[:app_name] = v }
    opt.on("--type=layout_type", String, "Specify the layout type") { |v| options[:layout_type] = v }
    opt.on("--theme=theme", String, "Specify the theme") { |v| options[:theme] = v }
    opt.on("--no-layout", "Don't create layout") { |v| options[:no_layout] = true }

    opt.on("--haml", "force the use of haml") { |v| options[:haml] = true }
    opt.on("--erb", "force the use of erb") { |v| options[:erb] = true }

    opt.on("--list", "Show available themes") { |v| options[:list] = true }
  end

  def haml?
    return false if options[:erb]
    return true  if options[:haml]
    File.exist?(destination_path('vendor/plugins/haml'))
  end

  def list_themes
    puts
    puts "  Available themes:"
    Dir.glob(source_path("../../../stylesheets/themes/*")).each do |t|
      puts "    - #{File.basename(t)}"
    end
    puts
    exit 0
  end
  
end
