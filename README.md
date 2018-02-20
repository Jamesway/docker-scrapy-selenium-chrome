## scrapy-selenium-chromw

Docker image with scrapy, selenium and chrome to run the scrapy demo: https://github.com/Jamesway/scrapy-demo

list commands for the scrapy project
```
docker run --rm -v $(pwd):/code -w /code/[scrapy_project] jamesway:scrapy-selenium-chrome
```

scrape to a json list
```
docker run --rm -v $(pwd):/code -w /code/[scrapy_project] jamesway:scrapy-selenium-chrome crawl spider_name -o result.jl
```
