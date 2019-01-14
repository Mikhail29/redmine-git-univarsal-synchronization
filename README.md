# Redmine Git Univarsal Synchronization

## Русский 

Данный модуль позволяет проводить синхронизацию локального хранилища и удаленного. Данный модуль универсальный так как может работать со всеми репозитория которые поддерживают веб хуки.
В настройках находятся такие параметры:
* Prune - добавляет параметр -p git fetch
* Автосоздание - позволяет клонировать репозиторий и добавлять автоматически в проект если указаны все необходимые параметры (перечень необходимых параметров смотрите ниже)
* Путь к папке с локальными репозиториями - абсолютный путь к папке где у Вас будут храниться локальные репозитории redmine, параметр обязателен если нужно использовать автосоздание репозиториев (именно по этому пути будут размещены все автоматически созданные репозитории)
* API ключ для вебхуков - случайная строка, некий ключ для валидации запросов вебхука

Для обновления существующих репозиториев обязательны только два параметра:
* key - он же api ключ, по сути в этом параметре передается ключ сохранённый в настройках модуля синхронизации для валидации запросов
* project_id - идентификатор проекта к которому относится данный репозиторий

Пример url вебхука только для обновления репозиториев проектов:
https://rm.mmwebstudio.pp.ua/git_sync_hook?key=xxxxxxxxxxxx&project_id=git-sync

Для обновления существующих репозиториев и автосоздание новых для проектов (работает если включено автосоздание и указан путь к локальному хранилищу) обязательны следующие параметры:
* key - он же api ключ, по сути в этом параметре передается ключ сохранённый в настройках модуля синхронизации для валидации запросов
* project_id - идентификатор проекта к которому относится данный репозиторий
* repository_name - имя репозитория, по сути это имя папки в локальном хранилище в которой будет размещен новый репозиторий при его автосоздание
* repository_git_url - url удаленного репозитория с которого нужно будет клонировать репозиторий локально если он не создан, указать можно как url для клонирования по git протоколу так и по https протоколу, и в том и в том случае будет верно работать.
Пример url для вебхука с автосоздание репозитория если он не существует:
https://rm.mmwebstudio.pp.ua/git_sync_hook?key=xxxxxxxxxxxxxxx&project_id=git-sync&repository_name=git-sync&repository_git_url=git@gitlab.com/mmwebstudioteam/repository.git

Так же я недавно включил в плагин Автоматическое слежение за изменениями при каждом git pull(fetch_changesets) поэтому  Автоматически следить за изменениями в админке redmine по пути Администрирование->Настройки->Хранилища лучше отключить

## English

This module allows you to synchronize local storage and remote storage. This module is universal as it can work with all repositories that support web hooks.
In the settings are the following parameters:
* Prune - add the -p git fetch parameter
* Auto-creation - allows you to clone the repository and add automatically to the project if all the necessary parameters are specified (see the list of necessary parameters below)
* Folder path with local repositories - the absolute path to the folder where you will have local redmine repositories stored, the parameter is required if you need to use auto-create repositories (this is the path where all automatically created repositories will be located)
* The API key for webbucks is a random string, a certain key for validating webhook requests
To update existing repositories, only two parameters are required:
* key - it is the api key, in fact, in this parameter, the key is transferred stored in the synchronization module settings for validating requests
* project_id - the project identifier to which this repository belongs
Example webhuk url only for updating project repositories:
https://rm.mmwebstudio.pp.ua/git_sync_hook?key=xxxxxxxxxxxx&project_id=git-sync

To update existing repositories and autocreate new projects (works if autocreation is enabled and the local storage path is specified) the following parameters are required:
* key - it is the api key, in fact, in this parameter, the key is transferred stored in the synchronization module settings for validating requests
* project_id - the project identifier to which this repository belongs
* repository_name is the name of the repository, in fact, this is the name of the folder in the local storage where the new repository will be located when it is auto-created
* repository_git_url - the url of the remote repository from which you need to clone the repository locally if it is not created, you can specify the url for cloning using the git protocol or the https protocol, and in that and in that case it will work correctly.
Example url for webhost with auto-create repository if it doesn't exist:
https://rm.mmwebstudio.pp.ua/git_sync_hook?key=xxxxxxxxxxxxxxx&project_id=git-sync&repository_name=git-sync&repository_git_url=git@gitlab.com/mmwebstudioteam/repository.git

I also recently included in the plugin Automatic tracking of changes with each git pull (fetch_changesets), so it is better to follow the changes in the admin panel of the redmine along the path Administration-> Settings-> Repositories to disable automatically
