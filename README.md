# certstream-test

An [Itamae](https://github.com/itamae-kitchen/itamae) script to deploy [certstream-server](https://github.com/CaliDog/certstream-server) on Ubuntu for testing purpose.

## Requirements

- Itamae
- Vagrant

## Usage

```bash
git clone https://github.com/ninoseki/certstream-test
cd certstream-test
vagrant up
itamae ssh --vagrant cookbooks/default.rb
```

Then certstream-server will work on `localhost:4000`.
