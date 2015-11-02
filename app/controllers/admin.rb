Honeybadger::App.controllers :admin do

  layout :admin

  before do
    @page = !params[:page].blank? ? @page = params[:page].to_i : 1
    @per_page = 15
  end

  get '/' do
    render "admin/index"
  end

  post '/data/(:cmd)', :provides => :js do

    rules = {
      :model => {:type => 'string', :min => 2, :required => true},
      :cmd => {:type => 'string', :min => 3, :required => true},
    }

    validator = Honeybadger::Validator.new(params, rules)
    if validator.valid?

      # get model obj
      model = Object.const_get(params[:model])

      # check if new or update
      if params[:id].blank?
        model.new
      else
        model = model[params[:id]]
      end

      case params[:cmd]
      when "save"
        model.set(params).save
        "alert('saved!');"
      when "delete"
        abort
        "delete"
      end
    else
      "not valid #{validator.errors}"
    end

  end

end
