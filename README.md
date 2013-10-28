## Enhanced queries

#### Plugin for Redmine

Plugin implements some queries improvements for Redmine.

Issue queries are splitted by categories. 
When you create new query, you need to specify Category name and Order number in queries list of this category.
Plugin also implements queries by members of the current project.

![Interface](https://github.com/dkuk/enhanced_queries/raw/master/screenshots/interface.png "Interface")
![Interface2](https://github.com/dkuk/enhanced_queries/raw/master/screenshots/interface2.png "Interface2")

In plugin settings you can specify link "project user role" - "issue user field" to specify filter in queries by members.

![Settings](https://github.com/dkuk/enhanced_queries/raw/master/screenshots/settings.png "settings")

#### Installation
To install plugin, go to the folder "plugins" in root directory of Redmine.
Clone plugin in that folder.

		git clone https://github.com/dkuk/enhanced_queries.git

Perform plugin migrations (make sure performing command in the root installation folder of «Redmine»):

		rake redmine:plugins:migrate NAME=enhanced_queries

Restart your web-server.

#### Supported Redmine, Ruby and Rails versions.

Plugin aims to support and is tested under the following Redmine implementations:
* Redmine 2.3.1
* Redmine 2.3.2
* Redmine 2.3.3

Plugin aims to support and is tested under the following Ruby implementations:
* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0

Plugin aims to support and is tested under the following Rails implementations:
* Rails 3.2.13

#### Copyright
Copyright (c) 2011-2013 Vladimir Pitin, Danil Kukhlevskiy.
