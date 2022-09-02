<p align="center">
  <img src="https://homeland.ruby-china.org/images/text-logo.svg" width="400">
  <p align="center">Open source discussion website.</p>
  <p align="center">开源的论坛／社区网站系统，基于 <a href="https://ruby-china.org">Ruby China</a> 发展而来。</p>
  <p align="center">
    <a href="https://github.com/ruby-china/homeland/actions">
      <img src="https://github.com/ruby-china/homeland/workflows/Test/badge.svg">
    </a>
  </p>
</p>

## Usage

- [DEPLOYMENT GUIDE](https://homeland.ruby-china.org)
- [EXAMPLE](https://homeland.ruby-china.org/expo)
- [RELEASE NOTES](https://github.com/ruby-china/homeland/releases)
- [CONTRIBUTE GUIDE](https://github.com/ruby-china/homeland/blob/master/CONTRIBUTE.md)

## License

Released under the MIT license:

- [www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)

## Export production DB and import into local dev

```bash
sudo su - thape_forum
pg_dump thape_forum_prod -O -x > thape_forum_prod.sql
zip thape_forum_prod.zip thape_forum_prod.sql
logout
scp thape_forum@thape_homeland:thape_forum_prod.zip .
unzip thape_forum_prod.zip
psql -d postgres
DROP DATABASE homeland-dev;
CREATE DATABASE "homeland-dev" WITH ENCODING='UTF8';
\q
psql -d 'homeland-dev' -f thape_forum_prod.sql
```
