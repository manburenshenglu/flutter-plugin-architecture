# App Shell Scaffold

Use one command to create a new app shell in this monorepo:

```bash
./tooling/create_app_shell.sh app_pharmacy consumer dev
```

Arguments:
- `app_name`: new directory under `apps/`
- `brand_profile`: `consumer` or `doctor`
- `env` (optional): `dev`, `staging`, `prod`

The generated app includes:
- unified bootstrap + module selector
- module debug page route
- shared module dependency set (`auth`, `home`, `profile`)

After generation:

```bash
cd apps/<app_name>
flutter pub get
flutter run
```

# Module Scaffold

Use one command to create a new module skeleton:

```bash
./tooling/create_module.sh module_orders
```

It generates:
- module package with standard dependencies
- `AppModule` entry + descriptor metadata
- `application/domain/presentation` skeleton

# Contract Compatibility

Before changing contract interfaces:

```bash
./tooling/check_contract_compatibility.sh
```

If you intentionally changed a contract with proper versioning:

```bash
./tooling/update_contract_lock.sh
```

# IDE Repair

If Android Studio run configurations become invalid (entrypoint/module mismatch), run:

```bash
./tooling/repair_flutter_ide.sh
```
