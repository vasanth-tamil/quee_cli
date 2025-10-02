# quee_cli

A command-line interface (CLI) for the `quee` package, designed to streamline your workflow.

## Installation

To use `quee_cli`, activate it globally using the following command:

```shell
dart pub global activate quee_cli
```

## Usage

Once activated, you can use the CLI as follows:

```shell
quee_cli <command> [arguments]
```

## Commands

Here are the available commands:

| Command      | Alias | Description                                                  | Options                                    |
|--------------|-------|--------------------------------------------------------------|--------------------------------------------|
| `page`       | `p`   | Generates a new page.                                        | `--default`, `-d` (Generate a default page) |
| `route`      | `r`   | Generates a new route and associates it with a page.         | `--page <name>`, `-p <name>`               |
| `controller` | `c`   | Generates a new controller.                                  | `--default`, `-d` (Generate a default controller) |
| `service`    | `s`   | Generates a new service.                                     | `--default`, `-d` (Generate a default service), `fetch:get`, `fetch:post`, `fetch:put`, `fetch:delete`, `fetch:patch` |
| `generate`   | `g`   | Generates a new model.                                       |                                            |
| `widget`     | `w`   | Generates a new widget.                                      | `--mock`, `-m` (Generate with mock data)   |
| `dialog`     | `d`   | Generates a new dialog.                                      | `info`, `confirm`, `error`, `success`, `warning`, `loading`, `alert`, `empty` |

### Examples

**Page**
```shell
quee_cli page <name>
quee_cli p <name>
quee_cli p <name> --default
```

**Route**
```shell
quee_cli route <name> --page <name>
quee_cli r <name> -p <name>
```

**Controller**
```shell
quee_cli controller <name>
quee_cli c <name> --default
```

**Service**
```shell
quee_cli service <name>
quee_cli s <name> --default
quee_cli s <name> fetch:get
```

**Model**
```shell
quee_cli generate <name>
quee_cli g <name>
dart run quee_cli:quee_cli -m name:orderOverview json:example/order_overview.json
```

**Widget**
```shell
quee_cli widget <name>
quee_cli w <name> --mock
```

**Dialog**
```shell
quee_cli dialog <name> info
quee_cli d <name> info

quee_cli dialog <name> confirm
quee_cli d <name> confirm

quee_cli dialog <name> error
quee_cli d <name> error

quee_cli dialog <name> success
quee_cli d <name> success

quee_cli dialog <name> warning
quee_cli d <name> warning

quee_cli dialog <name> loading
quee_cli d <name> loading

quee_cli dialog <name> alert
quee_cli d <name> alert

quee_cli dialog <name> empty
quee_cli d <name> empty
```

## Version

To check the version of `quee_cli`:

```shell
quee_cli --version
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
