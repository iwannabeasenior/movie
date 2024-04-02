class Instance {
  static String name = 'Jake Gyllenhaal';
  static String knownFor = 'Acting';
  static String credits = '116';
  static String gender = 'Male';
  static String birthday = 'December 19, 1980(43 year old)';
  static String placeOfBirth = 'Los Angeles, California, USA';
  static String bio = 'Jacob Benjamin Gyllenhaal (born December 19, 1980) is an American actor and producer. Born into the Gyllenhaal family, he is the son of director Stephen Gyllenhaal and screenwriter Naomi Foner; his older sister is actress Maggie Gyllenhaal. Read more';
  // 4 object in Known For
  static List<String> titles = ['Mario', 'Love and Monster', 'Napoleon', 'Rick Choice'];
  static Map<String, List<String>> movieByYear = {
    '2020': ['Mario', 'Naruto', 'HelloKitty'],
    '2018': ['Sonerio', 'I\'m on the fire'],
    '2017': ['Keep me doing this', 'Sorry for everything']
  };
  static List<Map<String, List<String>>>  movies = [
    {
      '2020': ['Mario', 'Naruto', 'HelloKitty'],
    },
    {
      '2018': ['Sonerio', 'I\'m on the fire'],
    },
    {
      '2017': ['Keep me doing this', 'Sorry for everything']
    }
  ];
}