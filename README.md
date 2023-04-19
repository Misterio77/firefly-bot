# Firefly Bot

A Telegram bot to create transactions in Firefly III
## Setup

First you'll have to generate a Telegram Bot token through [BotFather](https://t.me/botfather). Once you generate the token, keep it safe.

### Docker (Recommended)

```bash
docker create \
  --name=firefly-bot \ 
  -e TELEGRAM_BOT_TOKEN=<your-bot-token> \
  -v </path/to/config>:/config \
  vjfalk1/firefly-telegram-bot
```

### Nix

```bash
TELEGRAM_BOT_TOKEN=<your-bot-token> nix run github:shizunge/firefly-bot
```

Or clone the repository and run:
```bash
TELEGRAM_BOT_TOKEN=<your-bot-token> nix run
```

Alternatively, enter a shell with `nix develop` and run with `python -m firefly_bot`

### Poetry
- Clone the repository
- Install dependencies by running `poetry install`
- Run `TELEGRAM_BOT_TOKEN=<your-bot-token> poetry run firefly-bot`
    - Alternatively, enter a shell using `poetry shell` and run `python -m firefly_bot`

### Pip
- Clone the repository
- (Optional) Create and enter a virtualenv: `python3 -m venv .venv && source .venv/bin/activate`
- Install the dependencies by running: `pip install -r requirements.txt`
- Run `TELEGRAM_BOT_TOKEN=<your-bot-token> python -m firefly_bot`


---

## Usage

### Setup
- Once the bot is up and running, initiate a chat with the bot. Send `/start` to initiate setup 
  - `/start` can also be used to re-run the setup at a later time
- You will first be asked for your Firefly URL. Enter the full URL including the protocol. e.g. - `https://firefly.host.com`
  - Make sure **not** to include a trailing slash
- Second, you will be asked for your User Token. You will have to generate one from the profile section in your Firefly instance, under OAuth. 
- Lastly, you will be asked for a default account, by default all transactions will use this account as the source account, however, you can override it per transaction

### Creating a Transaction
All you need to do is send a message to the bot with the following format

```
Amount, Description, Category, Budget, Source account, Destination account
```

Only the first two values are needed. The rest are optional. The description value is used for destination account as well. 
  
**Examples**

A simple one - 

```
5, Starbucks
```

One with all the fields being used -

```
5, Mocha with an extra shot for Steve, Coffee, Food Budget, UCO Bank, Starbucks
```

You can skip specific fields by leaving them empty (except the first two) - 

```
5, Starbucks, , Food Budget, UCO Bank
```

You can also specify accounts by using their id instead of their name - 

```
5, Mocha with an extra shot for Steve, Coffee, Food Budget, 5, 35
```

---

### Notes

**Why Poetry AND requirements.txt?**
I don't want to use poetry inside Docker. It's unnecessary bloat and complexity. So I just generate a requirements.txt anytime I change deps using - `poetry export -f requirements.txt > requirements.txt`. It can then be used for Docker, or just anyone who wants to use this without having to install (and figure out) poetry.
