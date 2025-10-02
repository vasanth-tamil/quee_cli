# Quee CLI Example

This directory contains example JSON files that can be used with the `quee_cli` tool.

## Usage

To generate a model from a JSON file, run the following command from the root of the project:

```bash
dart run quee_cli --model name:<model_name> json:<path_to_json_file>
```

### Example: Generating a User Model

To generate a `User` model from the `user.json` file, run the following command:

```bash
dart run quee_cli --model name:user json:example/user.json
```

### Example: Generating an Order Overview Model

To generate an `OrderOverview` model from the `order_overview.json` file, run the following command:

```bash
dart run quee_cli --model name:order_overview json:example/order_overview.json
```
