# JQ for Windows

Step to make jq available in windos.

1. Download jq (jq-win64.exe) for windows. Try [this](https://github.com/stedolan/jq/releases/latest/download/jq-win64.exe)
2. Copy the file into C:\Windows
3. Rename the file as jq.exe

That's it! Now you can use it.

Example:

- To extract part of the json response
```
docker image inspect <image-name>:<image-ver> | jq '.[0] | .RootFS'
```

- To count the numner of elements in a section of the json response
```
docker image inspect postgres | jq '.[0] | {LayerCount: .RootFS.Layers | length}'
```

# CheetSheat Guide
A lightweight and flexible command-line JSON processor.
JQ is a command-line JSON processor that uses a domain-specific language.
More information [here](https://stedolan.github.io/jq/manual/).

### Basics

1. Output a JSON file, in pretty-print format:
```
jq
```

2. Output all elements from arrays (or all key-value pairs from objects) in a JSON file:
```
jq .[]
```

3. Read JSON objects from a file into an array, and output it (inverse of jq .[]):
```
jq --slurp
```

4. Output the first element in a JSON file:
```
jq .[0]
```

5. Output the value of a given key of the first element in a JSON file:
```
jq .[0].key_name
```

6. Output the value of a given key of each element in a JSON file:
```
jq 'map(.key_name)'
#
#     [ { foo: 1 }, { foo: 2 } ]
#     => [1, 2]
```

7. Extract as stream of values instead of a list
```
jq '.[] | .foo'
#
#     [ { "foo": 1 }, { "foo": 2 } ]
#     => 1, 2
```

8. Slicing
```
jq '.[1:2]'
#
#     [ { "foo": 1 }, { "foo": 2 } ]
#     => { "foo": 2 }
```

9. Dictionary subset shorthand
```
jq 'map({ a, b })'
#
#     [ { "a": 1, "b": 2, "c": 3 }, ...]
#     => [ { "a": 1, "b": 2 }, ...]
```

10. Converting arbitrary data to json
```
jq -r '(map(keys) | add | unique | sort) as $cols \
        | .[] as $row | $cols | map($row[.]) | @csv'
#
#     [ { "foo": 1, "bar": 2}, { "foo": 3, "baz": 4}]
#
#     => 2,,1
#      ,4,3
```

11. Filter a list of objects
```
jq 'map(select(.name == "foo"))'
#
#     [ { "name": "foo" }, { "name": "bar" } ]
#     => [ { "name": "foo" } ]
```

### Mapping and transforming

12. Add + 1 to all items
```
jq 'map(.+1)'
```

13. Delete 2 items
```
jq 'del(.[1, 2])'
```

14. Concatenate arrays
```
jq 'add'
```

15. Flatten an array
```
jq 'flatten'
#
#     [[1], [2]]
#     => [1, 2]
```

16. Create a range of numbers
```
jq '[range(2;4)]'
```

17. Display the type of each item
```
jq 'map(type)'
```

18. Sort an array of basic type
```
jq 'sort'
#
#     [3, 2, 1]
#     => [1, 2, 3]
```

19. Sort an array of objects
```
jq 'sort_by(.foo)'
```

20. Sort lines of a file
```
jq --slurp '. | sort | .[]'
```

21. Group by a key - opposite to flatten
```
jq 'group_by(.foo)'
```

22. Minimum value of an array
```
jq 'min'
# See also min, max, min_by(path_exp), max_by(path_exp)
```

23. Remove duplicates
```
jq 'unique'
# or
jq 'unique_by(.foo)'
# or
jq 'unique_by(length)'
#
#   [1, 1, 2, 1]
#   => [1, 2]
```

24. Reverse an array
```
jq 'reverse'
```

### jq in shell scripts

25.  URL Encode something
```
date | jq -sRr @uri
# Thu%2021%20May%202020%2012%3A40%3A40%20PM%20CEST%0A
```

26.  To create proper JSON from a shell script and properly escape variables:
```
jq -n --arg foobaz "$FOOBAZ" '{"foobaz":$foobaz}'
```

27. To fill environment variables from JSON object keys
```
# (e.g. $FOO from jq query ".foo")
export $(jq -r '@sh "FOO=\(.foo) BAZ=\(.baz)"')
```

### Input/output formats

28. Parsing json
```
jq 'with_entries(.value |= fromjson)' --sort-keys
#
#     { "b": "{}", "a": "{}" }
#     =>  { "a": {}, "b": {} }
```

29. Serializing json
```
jq 'with_entries(.value |= tojson)' --sort-keys
#
#     { "a": {}, "b": {} }
#     => { "a": "{}", "b": "{}" }
```

30. Converting to csv
```
jq '.[] | [.foo, .bar] | @csv' -r
#
#     [{ "foo": 1, "bar": 2, "baz":3 }]
#     => 1,2
```

31. To pretty print the json:
```
jq "." < filename.json
```

32. To access the value at key "foo":
```
jq '.foo'
```

33. To access first list item:
```
jq '.[0]'
```

34. to slice and dice:
```
jq '.[2:4]'
jq '.[:3]'
jq '.[-2:]'
```

35. to extract all keys from json:
```
jq keys
```

36. to sort by a key:
```
jq '.foo | sort_by(.bar)'
```

37. to count elements:
```
jq '.foo | length'
```

38. print only selected fields:
```
jq '.foo[] | {field_1,field_2}'
```

39. print selected fields as text instead of json:
```
jq '.foo[] | {field_1,field_2} | join(" ")'
```

40. only print records where given field matches a value
```
jq '.foo[] | select(.field_1 == "value_1")'
```

41. Execute a specific expression (print a colored and formatted json):
```
cat path/to/file.json | jq '.'
```

42. Execute a specific script:
```
cat path/to/file.json | jq --from-file path/to/script.jq
```

43. Pass specific arguments:
```
cat path/to/file.json | jq --arg "name1" "value1" --arg "name2" "value2" ... '. + $ARGS.named'
```

44. Print specific keys:
```
cat path/to/file.json | jq '.key1, .key2, ...'
```

45. Print specific array items:
```
cat path/to/file.json | jq '.[index1], .[index2], ...'
```

46. Print all array items/object keys:
```
cat path/to/file.json | jq '.[]'
```

47. Add/remove specific keys:
```
cat path/to/file.json | jq '. +|- {"key1": "value1", "key2": "value2", ...}'
```

Source: [http://cht.sh/jq](http://cht.sh/jq)
