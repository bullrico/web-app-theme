class ThemeGenerator < Rails::Generator::Base
  
  default_options :app_name => 'Web App',
                  :layout_type => :administration,
                  :theme => :default,
                  :no_layout => false,
                  :erb => false,
                  :haml => false,
                  :list => false,
                  :sass_dir => "app/stylesheets/themes"
    
  def initialize(runtime_args, runtime_options = {})
    super
    @name = @args.first || (options[:layout_type].to_s == "sign" ? "sign" : "application")
    list_themes if options[:list]
  end
  
  def manifest
    record do |m|            
      m.directory("app/views/layouts")
      if haml?
        m.template("view_layout_#{options[:layout_type]}.html.haml", File.join("app/views/layouts", "#{@name}.html.haml")) unless options[:no_layout]

        # Base
        frompath = "../../../stylesheets/sass/base"
        topath   = "#{options[:sass_dir]}/base"
        m.directory(topath)
        m.template(File.join(frompath, '_base.sass'), File.join(topath, '_base.sass'))
        m.template(File.join(frompath, '_footer.sass'), File.join(topath, '_footer.sass'))
        m.template(File.join(frompath, '_form.sass'), File.join(topath, '_form.sass'))
        m.template(File.join(frompath, '_header.sass'), File.join(topath, '_header.sass'))
        m.template(File.join(frompath, '_main.sass'), File.join(topath, '_main.sass'))
        m.template(File.join(frompath, '_navigation.sass'), File.join(topath, '_navigation.sass'))
        m.template(File.join(frompath, '_pagination.sass'), File.join(topath, '_pagination.sass'))
        m.template(File.join(frompath, '_sidebar.sass'), File.join(topath, '_sidebar.sass'))

        # Theme
        frompath = "../../../stylesheets/sass/default"
        topath   = "#{options[:sass_dir]}/#{options[:theme]}"
        m.directory(topath)
        m.template(File.join(frompath, '_corners.sass'), File.join(topath, '_corners.sass'))
        m.template(File.join(frompath, '_flash.sass'), File.join(topath, '_flash.sass'))
        m.template(File.join(frompath, '_footer.sass'), File.join(topath, '_footer.sass'))
        m.template(File.join(frompath, '_form.sass'), File.join(topath, '_form.sass'))
        m.template(File.join(frompath, '_header.sass'), File.join(topath, '_header.sass'))
        m.template(File.join(frompath, '_main.sass'), File.join(topath, '_main.sass'))
        m.template(File.join(frompath, '_navigation.sass'), File.join(topath, '_navigation.sass'))
        m.template(File.join(frompath, '_pagination.sass'), File.join(topath, '_pagination.sass'))
        m.template(File.join(frompath, '_sidebar.sass'), File.join(topath, '_sidebar.sass'))
        m.template(File.join(frompath, 'screen.sass'), File.join(topath, '_screen.sass'))

        m.template("web_app_theme_override.sass",  File.join("#{options[:sass_dir]}/default/", "screen.sass"))
      else
        m.directory("app/stylesheets/themes/#{options[:theme]}/")
        m.template("view_layout_#{options[:layout_type]}.html.erb", File.join("app/views/layouts", "#{@name}.html.erb")) unless options[:no_layout]
        m.template("../../../stylesheets/base.css",  File.join("public/stylesheets/themes", "web_app_theme.css"))
        m.template("web_app_theme_override.css",  File.join("public/stylesheets/themes", "web_app_theme_override.css"))
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
    opt.on("--sass_dir", "Sass directory") { |v| options[:sass_dir] = v }
    
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
