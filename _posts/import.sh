ruby -r rubygems -e 'require "jekyll-import";
    JekyllImport::Importers::WordPress.run({
      "dbname"         => "epa",
      "user"           => "root",
      "password"       => "anaplan123",
      "host"           => "127.0.0.1",
      "port"           => "3310",
      "extension"      => "md"
})'
