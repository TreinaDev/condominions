# Onde a biblioteca I18n deve procurar arquivos de tradução
I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

# Localidades permitidas disponíveis para a aplicação
I18n.available_locales = [:en, :"pt-BR"]

# Definir localidade padrão para algo diferente de :en
I18n.default_locale = :"pt-BR"