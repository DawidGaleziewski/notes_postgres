We create a idex on a row. We specify what type it is. By default it is btree
```postgresql
CREATE INDEX idx_content_btree 
ON textfun USING btree (content);
```