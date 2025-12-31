# type_cast

post['comments'] as List<dynamic>? 

as List<dynamic>? is a type cast in Dart.
It tells Dart: “I expect post['comments'] to either be a List<dynamic> or null.”
So effectively:
If post['comments'] is a list, the cast succeeds.
If post['comments'] is null, that’s also fine because of ?.
If it’s something else (like a String or int), Dart will throw a runtime error.
This cast is necessary because data from Firestore is dynamic by default. Dart doesn’t know its type until you tell it.

why we can’t just do List<Map<String, dynamic>> and why List<dynamic> is used instead.

1️⃣ What Firestore returns

When you fetch a document from Firestore in Flutter using doc.data():
Firestore returns a Map<String, dynamic> for the document.
Each field inside is also dynamic.
So post['comments'] is dynamic.
Firestore doesn’t guarantee Dart types at runtime—everything comes as dynamic.
For example, a comments field in Firestore:
"comments": [
  {"author": "Alice", "text": "Nice post!"},
  {"author": "Bob", "text": "I agree!"}
]

Firestore converts this into a Dart List<Map<String, dynamic>> internally, but Dart sees it as dynamic.

2️⃣ Why not List<Map<String, dynamic>> directly?
You might think:
final comments = post['comments'] as List<Map<String, dynamic>>?;
Sounds good, right? But there’s a catch: Dart’s type system is strict.

Here’s why it can fail:

Firestore’s list is actually List<dynamic>, where each element is a Map<String, dynamic>.

Dart doesn’t consider List<dynamic> a subtype of List<Map<String, dynamic>>.

Even if every element is a Map<String, dynamic>, the container type is different.

That’s because Dart’s generics are invariant, not covariant.

So doing as List<Map<String, dynamic>> often throws a runtime error:

type 'List<dynamic>' is not a subtype of type 'List<Map<String, dynamic>>'

3️⃣ Why List<dynamic> works

By first casting to List<dynamic>:
post['comments'] as List<dynamic>?

You tell Dart: “I just want a list of something. I’ll handle the elements myself.”

Then you map each element to Map<String, dynamic> safely:

.map((e) => Comments.fromMap(e as Map<String, dynamic>))

This way, you check the type of each element individually, which avoids runtime errors with Dart’s invariant generics.


1️⃣ Firestore’s internal representation

Firestore stores arrays as JSON-like arrays of objects.
When you fetch a document in Flutter using doc.data(), the Firestore SDK converts the data into Dart native types:
Strings → String
Numbers → int/double
Arrays → List<dynamic>
Maps → Map<String, dynamic>
So your comments field is represented internally as a List<dynamic>, where each element happens to be a Map<String, dynamic>.

2️⃣ Why Dart sees it as dynamic

The type of post['comments'] is dynamic, because Firestore returns a Map<String, dynamic> for the whole document.
Dart doesn’t know the element types inside the list. So from Dart’s perspective, it’s just dynamic.