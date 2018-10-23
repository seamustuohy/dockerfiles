
## [Cyobstract](https://github.com/cmu-sei/cyobstract): A tool to extract structured cyber information from incident reports.


## Bash Alias


```bash
cyobstract() {
    docker run --rm -it \
        --net host \
        ${DOCKER_REPO_PREFIX}/cyobstract "$@"
}
```

## Using cyobstract

### Ignore Empty Indicator Fields (-i)

You can use `--ignore_missing` or the `-i` flag to not print indicator types that didn't find anything.
```bash
cyobstract --ignore_missing "https://citizenlab.ca/2018/10/the-kingdom-came-to-canada-how-saudi-linked-digital-espionage-reached-canadian-soil/"
```

#### Output

```
=== fqdn ===
akhbar-arabia.com
all-sales.info
arabnews365.com
arabworld.biz
beststores4u.com
cheapapartmentsaroundme.com
daily-sport.news
dinneraroundyou.com
findmyplants.com
housesfurniture.com
kingdom-deals.com
kingdom-news.com
mideast-today.com
muslim-world.info
news-gazette.info
nouvelles247.com
promosdereve.com
social-life.info
sunday-deals.com
wonderfulinsights.com


=== filename ===
Driving.pptx


=== cc ===
Bahrain
Canada
Egypt
European Union
France
Iraq
Israel
Jordan
Lebanon
Mexico
Morocco
Panama
Qatar
Saudi Arabia
Turkey
United Arab Emirates


=== topic ===
C2
exfiltration
hacking
infection
probe
scanning
spying
spyware
zero-day
```

### Include Empty Sections
You can leave the `-i` flag off the command to show the fields that didn't find anything.

```bash
cyobstract "https://citizenlab.ca/2018/10/the-kingdom-came-to-canada-how-saudi-linked-digital-espionage-reached-canadian-soil/"
```

```

=== ipv4addr ===


=== ipv6addr ===


=== ipv4range ===


=== ipv6range ===


=== ipv4cidr ===


=== ipv6cidr ===


=== asn ===


=== fqdn ===
akhbar-arabia.com
all-sales.info
arabnews365.com
arabworld.biz
beststores4u.com
cheapapartmentsaroundme.com
daily-sport.news
dinneraroundyou.com
findmyplants.com
housesfurniture.com
kingdom-deals.com
kingdom-news.com
mideast-today.com
muslim-world.info
news-gazette.info
nouvelles247.com
promosdereve.com
social-life.info
sunday-deals.com
wonderfulinsights.com


=== email ===


=== filename ===
Driving.pptx


=== url ===


=== md5 ===


=== sha1 ===


=== sha256 ===


=== ssdeep ===


=== filepath ===


=== regkey ===


=== useragent ===


=== cve ===


=== cc ===
Bahrain
Canada
Egypt
European Union
France
Iraq
Israel
Jordan
Lebanon
Mexico
Morocco
Panama
Qatar
Saudi Arabia
Turkey
United Arab Emirates


=== isp ===


=== asnown ===


=== incident ===


=== malware ===


=== topic ===
C2
exfiltration
hacking
infection
probe
scanning
spying
spyware
zero-day
```
