# Predicate interface 

Predicate<String> istNull = str -> str == null;
  Predicate<String> istLeer = String::isEmpty;
  Predicate<Person> istErwachsen =
       person -> person.getAlter() >= 18;


* Namen mit G

public static void filter(List<String> namen, Predicate<String> filter) {
namen.forEach(name -> {
if (filter.test(name)) { System.out.println(name); }
}); }
List<String> namen = new ArrayList<String>(Arrays.asList("Gandalf", "Aragorn", „Frodo", "Gimli"));
Predicate<String> beginntMitG = name ->
    name.toUpperCase().startsWith("G");
filter(namen, beginntMitG);

* Collection.removeIf(Predicate<T>)

UnaryOperator<String> ausNullMachLeer =
       str -> str == null ? "" : str;
  ausNullMachLeer.apply(null) → ""
  ausNullMachLeer.apply("Mike") → "Mike"

* void replaceAll(UnaryOperator<T>);


