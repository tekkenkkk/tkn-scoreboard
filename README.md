<br>

```console
tekkenkkk@github:~$ ./tkn-scoreboard
```

<img width="650px" src="https://i.imgur.com/mhe8zVb.png"/>
<br>

![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Ftekkenkkk%2Ftkn-scoreboard&count_bg=%23095F99&title_bg=%232A2D33&icon=github.svg&icon_color=%23FFFFFF&title=Visits&edge_flat=true)

<h1>Requirements</h1>

```es_extended```
<h3>Add esx:setGroup event to your es_extended</h3>

`es_extended/server/classes/player.lua`

```lua
TriggerEvent('esx:setGroup', self.source, self.group)
```

<img width="650px" src="https://i.imgur.com/AyymRtw.png">

<h1>Usage</h1>

Change server logo:<br>
```assets/logo.png```

Add following command to server config file:<br>
```ensure tkn-scoreboard```

<h1>Preview</h1>
<img src="https://i.imgur.com/rg4Vazz.png">
<img src="https://i.imgur.com/ud3fO8W.png">
