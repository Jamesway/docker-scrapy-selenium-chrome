# Scrapy Python Scraper with Selenium, Chrome Browser and Chrome Driver...
... with SQLAlchemy and BeautifulSoup4

Demo: https://github.com/jamesway/scrapy-demo

## Requirements
- docker



## Usage

### list scrapy commands
```
docker run --rm jamesway/scrapy
```

### start a project
```
#the container WORKDIR is /code
docker run --rm -v $(pwd):/code jamesway/scrapy startproject [scrapy_project_name]
```  

### create a spider for a domain
```
cd [scrapy_project_name]
docker run --rm -v $(pwd):/code jamesway/scrapy genspider [spider_name] [domain.com]

#eg
docker run --rm -v $(pwd):/code jamesway/scrapy genspider example example.com
```  

### crawl
```
# -o specifies output type eg: json list (.jl)
docker run --rm -v $(pwd):/code jamesway/scrapy crawl [spider_name] -o [output_file.jl]
```
