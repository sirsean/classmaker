Generate the boilerplate for your Java classes, interfaces, and unit tests. This way, you don't have to remember how to do it yourself.

## Install

```
rake gem:build
rake gem:install
```

## Copy the templates

```
cp -R templates ~/.classmaker
```

You can tweak the templates, if you want to.

### Usage

Create an interface:

```
classmaker package=com.vikinghammer.example --interface
```

It will ask you for the name of your interface and create it at ```src/main/java/com/vikinghammer/example```.

And a class:

```
classmaker package=com.vikinghammer.example.impl
```

It will ask you for the name of your class, and let you describe what fields it has.

```
fieldOne:String
fieldTwo:Date
fieldThree:Long:y
```

That'll create those three fields _and a getter/setter for fieldThree_, because of that trailing ":y".

And a class for unit tests:

```
classmaker package=com.vikinghammer.example --test
```

It will ask you for the name of your test class, and create it at ```src/test/java/com/vikinghammer/example```.

In all cases, if that directory doesn't exist, it will be created for you.
