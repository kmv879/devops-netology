﻿1. git show aefea\
   Полный хэш aefead2207ef7e2aa5dc81a34aedf0cad4c32545\
   Комментарий Update CHANGELOG.md
2. git show 85024d3\
   Коммит соответствует тегу v0.12.23
3. git show b8d720\
   Коммит - результат мерджа 56cd7859e и  9ea88f22f\
   Родители коммита:\
56cd7859e05c36c06b56d013b55a252d0bb7e158\
9ea88f22fc6269854151c571162c5bcf958bee2b
4. git log v0.12.23..v0.12.24 --oneline\
Коммиты между тегами v0.12.23 и v0.12.24:\
b14b74c49 [Website] vmc provider links \
3f235065b Update CHANGELOG.md\
6ae64e247 registry: Fix panic when server is unreachable\
5c619ca1b website: Remove links to the getting started guide's old location\
06275647e Update CHANGELOG.md\
d5f9411f5 command: Fix bug when using terraform login on Windows\
4b6d06cc5 Update CHANGELOG.md\
dd01a3507 Update CHANGELOG.md\
225466bc3 Cleanup after v0.12.23 release
5. git log -S "func providerSource("\
Функция создана в коммите 8c928e83589d90a031f811fae52a81be7153e82f
6. Поиск коммита и файла, в котором функция определена\
git log -S "func globalPluginDirs("\
Поиск коммитов с изменением функции\
git log -L :globalPluginDirs:plugins.go\
Функция была изменена в коммитах:\
78b122055 Remove config.go and update things using its aliases\
52dbf9483 keep .terraform.d/plugins for discovery\
41ab0aef7 Add missing OS_ARCH dir to global plugin paths\
66ebff90c move some more plugin search path logic to command\
8364383c3 Push plugin discovery down into command package (Создана)
7. Автор функции Martin Atkins <mart@degeneration.co.uk>\
Поиск коммита и файла, в котором функция определена\
git log -S "func synchronizedWriters("\
Автор коммита - автор функции.\
Тот же результат дает переход на этот коммит\
git checkout 5ac311e2a91e381e2f52234668b49ba670aa0fe5\
и\
git blame synchronized_writers.go\
5ac311e2a9 (Martin Atkins 2017-05-03 16:25:41 -0700 15) func synchronizedWriters(targets ...io.Writer) []io.Writer {
