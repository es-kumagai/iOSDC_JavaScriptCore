var timeout = 5.0;
var attributes = { 'name' : 'kumagai', 'region' : 'JP' };

function Article(title, body)
{
    this.title = title;
    this.body = body;
}

Article.prototype.getDescription = function()
{
    return this.body.substr(0, 10);
}

function getAttribute(name)
{
    return attributes[name];
}
