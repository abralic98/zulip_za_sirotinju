#!/bin/bash

mix ecto.migrate && _build/dev/rel/zulip_za_sirotinju/bin/zulip_za_sirotinju start
