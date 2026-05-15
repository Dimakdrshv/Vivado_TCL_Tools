# Vivado Tcl Tools

Набор Tcl-скриптов для автоматизации разработки FPGA-проектов в Xilinx Vivado. Проект на данном этапе разработки не поддерживает интеграцию с IP-ядрами.

## Требуемая структура проекта

Для корректной работы скриптов Ваш проект должен иметь следующую структуру:

```text
project_root/
├── build/
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
| `files/sources/` | HDL-исходники (.v .sv .mem) |
| `files/simulations/` | Testbench и simulation files (.v .sv .mem) |
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

<img width="660" height="116" alt="image" src="https://github.com/user-attachments/assets/a528e953-b9ab-4827-9c30-38d764c1c298" />

## Использование Tcl-скриптов

### build_project.tcl

Скрипт автоматического создания или пересборки проекта. Скрипт автоматически собирает проект исходя из файлов в каталоге `files/`

Для подключения скрипта выполните в TCL Console:

```tcl
cd <path to local project>
source scripts/build_project.tcl
```

После этого станет доступна команда `build_project <part>` внутри Vivado:

<img width="1917" height="817" alt="image" src="https://github.com/user-attachments/assets/4cfa8ee9-53fb-439a-8a86-e46aba9881cd" />

Создание проекта для конкретной FPGA:

```tcl
build_project <some_part>
```

Создание проекта для FPGA xc7a100tcsg324-1:

```tcl
build_project
```

<img width="1920" height="1031" alt="image" src="https://github.com/user-attachments/assets/1fb21dda-1d79-4d5f-8eb8-bf1e86c0968d" />

### create_file.tcl

Скрипт создания новых файлов. Поддерживаются файлы формата **.v .sv .mem** для дизайна и симуляции, **.xdc** для проектных ограничений.

Пример использования:

```tcl
source scripts/create_file.tcl
new_source_file my_module.v
```

<img width="1920" height="1021" alt="image" src="https://github.com/user-attachments/assets/46ef907d-d91b-4803-97fe-7bb29b4948a5" />


### delete_file.tcl

Скрипт удаления файлов проекта. Поддерживаются файлы формата **.v .sv .mem .xdc**

Пример использования:

```tcl
source scripts/delete_file.tcl
delete_source_file my_module.v
```

<img width="1920" height="1040" alt="image" src="https://github.com/user-attachments/assets/cb670292-9429-47df-a0ae-fd4f595c9063" />

# Требования

- Xilinx Vivado
- Tcl support
- Git

# License

MIT License
