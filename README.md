# Vivado Tcl Tools

Набор Tcl-скриптов для автоматизации разработки FPGA-проектов в САПР Vivado.

## Требуемая структура проекта

Для корректной работы скриптов Ваш проект должен иметь следующую структуру:

```text
project_root/
├── build/
├── ip/
├── files/
│   ├── sources/
│   ├── simulations/
│   └── constraints/
├── scripts/
├── ...
```

Описание директорий:

| Папка | Назначение |
|---|---|
| `build/` | Генерируемый Vivado-проект (сгенерируется при использовании скриптов локально) |
| `ip/` | IP-ядра (.xci) |
| `files/sources/` | HDL-исходники (.v .sv .mem .vh) |
| `files/simulations/` | Testbench и simulation files (.v .sv .mem .vh) |
| `files/constraints/` | XDC constraints |
| `scripts/` | Tcl automation scripts |

## Подключение как Git Submodule

Рекомендуется подключать репозиторий как submodule внутрь FPGA-проекта.

Добавление submodule:

```bash
git submodule add <repository_url> scripts
```

Для обновления submodule можно использовать команду:

```bash
git submodule update --init --recursive
```

Ваш локальный проект на данном этапе должен выглядить следующим образом:

<img width="695" height="530" alt="image" src="https://github.com/user-attachments/assets/4de463aa-008c-48d8-8bcf-3101ce018285" />

## Использование Tcl-скриптов

### build_project.tcl

Скрипт автоматического создания или пересборки проекта. Скрипт автоматически собирает проект исходя из файлов в каталогах `files/` и `ip/`. (IP-ядра всегда подтягиваются в файлсет **sources_1**)

Для подключения скрипта выполните в TCL Console:

```tcl
cd <path to local project>
source scripts/build_project.tcl
```

После этого станет доступна команда `build_project <part>` внутри Vivado.

Создание проекта для конкретной FPGA:

```tcl
build_project <part>
```

Создание проекта для FPGA xc7a100tcsg324-1:

```tcl
build_project
```

### create_file.tcl

Скрипт создания новых файлов. Поддерживаются файлы формата **.v .sv .mem .vh** для дизайна и симуляции, **.xdc** для проектных ограничений. Файлы автоматически создаются в соответствующем каталоге `files/*` и подтягиваются в проект.

Пример использования:

```tcl
source scripts/create_file.tcl
new_source_file my_module.v
new_simulation_file my_testbench.sv
new_constraint_file my_constraints.xdc
```

### delete_file.tcl

Скрипт удаления файлов проекта. Поддерживаются файлы формата **.v .sv .mem .xdc .vh .xci**. Данные файлы удаляются из директорий `files/*` и `ip/`. Для получения проекта без этих файлов после удаления рекомендую пересобрать проект.

Пример использования:

```tcl
source scripts/delete_file.tcl
delete_source_file my_module.v
delete_simulation_file my_testbench.sv
delete_constraint_file my_constraints.xdc
delete_ip_file my_ip.xci
```

### export_sources.tcl

Данный скрипт необходим в том случае, если вы создаете файлы через GUI интерфейс САПР Vivado или хотите экспортировать IP-ядро из проекта. Поддерживаются файлы формата **.v .sv .mem .xdc .vh .xci**. Данные файлы экспортируются в соответствующие директории `files/*` или `ip/` в зависимости от введенной команды.

Пример использования:

```tcl
source scripts/export_sources.tcl
export_design_source abc.v
export_simulation_source testbench.sv
export_constraints_source constraints.xdc
export_ip_source my_ip.xci
```

### Дополнительная информация

При использовании команд, указанных ниже, смотрите выводимые в консоль подсказки.

```tcl
source scripts/build_project.tcl
source scripts/create_file.tcl
source scripts/delete_file.tcl
source scripts/export_sources.tcl
```

В случае, если Вы нашли ошибку в скриптах, то делайте PR - исправим :)

Также если у Вас есть интересные идеи для новых скриптов, то делайте fork и также закидывайте PR *=

# Требования

- САПР Vivado
- Tcl support
- Git

# License

MIT License
