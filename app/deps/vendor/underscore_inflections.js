define(['underscore', 'underscore.string'], function(_, Strings) {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  var Inflections;
  Inflections = (function() {
    Inflections.prototype.defaultUncountables = ['equipment', 'information', 'rice', 'money', 'species', 'series', 'fish', 'sheep', 'jeans', 'moose', 'deer', 'news', 'music'];

    Inflections.prototype.defaultPluralRules = [[/$/, 's'], [/s$/i, 's'], [/^(ax|test)is$/i, '$1es'], [/(octop|vir)us$/i, '$1i'], [/(octop|vir)i$/i, '$1i'], [/(alias|status)$/i, '$1es'], [/(bu)s$/i, '$1ses'], [/(buffal|tomat)o$/i, '$1oes'], [/([ti])um$/i, '$1a'], [/([ti])a$/i, '$1a'], [/sis$/i, 'ses'], [/(?:([^f])fe|([lr])f)$/i, '$1$2ves'], [/(hive)$/i, '$1s'], [/([^aeiouy]|qu)y$/i, '$1ies'], [/(x|ch|ss|sh)$/i, '$1es'], [/(matr|vert|ind)(?:ix|ex)$/i, '$1ices'], [/(m|l)ouse$/i, '$1ice'], [/(m|l)ice$/i, '$1ice'], [/^(ox)$/i, '$1en'], [/^(oxen)$/i, '$1'], [/(quiz)$/i, '$1zes']];

    Inflections.prototype.defaultSingularRules = [[/s$/i, ''], [/(ss)$/i, '$1'], [/(n)ews$/i, '$1ews'], [/([ti])a$/i, '$1um'], [/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$/i, '$1$2sis'], [/(^analy)(sis|ses)$/i, '$1sis'], [/([^f])ves$/i, '$1fe'], [/(hive)s$/i, '$1'], [/(tive)s$/i, '$1'], [/([lr])ves$/i, '$1f'], [/([^aeiouy]|qu)ies$/i, '$1y'], [/(s)eries$/i, '$1eries'], [/(m)ovies$/i, '$1ovie'], [/(x|ch|ss|sh)es$/i, '$1'], [/(m|l)ice$/i, '$1ouse'], [/(bus)(es)?$/i, '$1'], [/(o)es$/i, '$1'], [/(shoe)s$/i, '$1'], [/(cris|test)(is|es)$/i, '$1is'], [/^(a)x[ie]s$/i, '$1xis'], [/(octop|vir)(us|i)$/i, '$1us'], [/(alias|status)(es)?$/i, '$1'], [/^(ox)en/i, '$1'], [/(vert|ind)ices$/i, '$1ex'], [/(matr)ices$/i, '$1ix'], [/(quiz)zes$/i, '$1'], [/(database)s$/i, '$1']];

    Inflections.prototype.defaultIrregularRules = [['person', 'people'], ['man', 'men'], ['child', 'children'], ['sex', 'sexes'], ['move', 'moves'], ['cow', 'kine'], ['zombie', 'zombies']];

    Inflections.prototype.defaultHumanRules = [];

    function Inflections() {
      this.apply_inflections = bind(this.apply_inflections, this);
      this.titleize = bind(this.titleize, this);
      this.humanize = bind(this.humanize, this);
      this.underscore = bind(this.underscore, this);
      this.camelize = bind(this.camelize, this);
      this.singularize = bind(this.singularize, this);
      this.pluralize = bind(this.pluralize, this);
      this.clearInflections = bind(this.clearInflections, this);
      this.human = bind(this.human, this);
      this.uncountable = bind(this.uncountable, this);
      this.irregular = bind(this.irregular, this);
      this.singular = bind(this.singular, this);
      this.plural = bind(this.plural, this);
      this.acronym = bind(this.acronym, this);
      this.applyDefaultPlurals = bind(this.applyDefaultPlurals, this);
      this.applyDefaultUncountables = bind(this.applyDefaultUncountables, this);
      this.applyDefaultRules = bind(this.applyDefaultRules, this);
      this.plurals = [];
      this.singulars = [];
      this.uncountables = [];
      this.humans = [];
      this.acronyms = {};
      this.applyDefaultRules();
    }

    Inflections.prototype.applyDefaultRules = function() {
      this.applyDefaultUncountables();
      this.applyDefaultPlurals();
      this.applyDefaultSingulars();
      return this.applyDefaultIrregulars();
    };

    Inflections.prototype.applyDefaultUncountables = function() {
      return this.uncountable(this.defaultUncountables);
    };

    Inflections.prototype.applyDefaultPlurals = function() {
      return _.each(this.defaultPluralRules, (function(_this) {
        return function(rule) {
          var capture, regex;
          regex = rule[0], capture = rule[1];
          return _this.plural(regex, capture);
        };
      })(this));
    };

    Inflections.prototype.applyDefaultSingulars = function() {
      return _.each(this.defaultSingularRules, (function(_this) {
        return function(rule) {
          var capture, regex;
          regex = rule[0], capture = rule[1];
          return _this.singular(regex, capture);
        };
      })(this));
    };

    Inflections.prototype.applyDefaultIrregulars = function() {
      return _.each(this.defaultIrregularRules, (function(_this) {
        return function(rule) {
          var plural, singular;
          singular = rule[0], plural = rule[1];
          return _this.irregular(singular, plural);
        };
      })(this));
    };

    Inflections.prototype.acronym = function(word) {
      this.acronyms[word.toLowerCase()] = word;
      return this.acronym_matchers = _.values(this.acronyms).join("|");
    };

    Inflections.prototype.plural = function(rule, replacement) {
      if (typeof rule === 'string') {
        delete this.uncountables[_.indexOf(this.uncountables, rule)];
      }
      delete this.uncountables[_.indexOf(this.uncountables, replacement)];
      return this.plurals.unshift([rule, replacement]);
    };

    Inflections.prototype.singular = function(rule, replacement) {
      if (typeof rule === 'string') {
        delete this.uncountables[_.indexOf(this.uncountables, rule)];
      }
      delete this.uncountables[_.indexOf(this.uncountables, replacement)];
      return this.singulars.unshift([rule, replacement]);
    };

    Inflections.prototype.irregular = function(singular, plural) {
      delete this.uncountables[_.indexOf(this.uncountables, singular)];
      delete this.uncountables[_.indexOf(this.uncountables, plural)];
      if (singular.substring(0, 1).toUpperCase() === plural.substring(0, 1).toUpperCase()) {
        this.plural(new RegExp("(" + (singular.substring(0, 1)) + ")" + (singular.substring(1, plural.length)) + "$", "i"), '$1' + plural.substring(1, plural.length));
        this.plural(new RegExp("(" + (plural.substring(0, 1)) + ")" + (plural.substring(1, plural.length)) + "$", "i"), '$1' + plural.substring(1, plural.length));
        return this.singular(new RegExp("(" + (plural.substring(0, 1)) + ")" + (plural.substring(1, plural.length)) + "$", "i"), '$1' + singular.substring(1, plural.length));
      } else {
        this.plural(new RegExp("" + (singular.substring(0, 1)) + (singular.substring(1, plural.length)) + "$", "i"), plural.substring(0, 1) + plural.substring(1, plural.length));
        this.plural(new RegExp("" + (singular.substring(0, 1)) + (singular.substring(1, plural.length)) + "$", "i"), plural.substring(0, 1) + plural.substring(1, plural.length));
        this.plural(new RegExp("" + (plural.substring(0, 1)) + (plural.substring(1, plural.length)) + "$", "i"), plural.substring(0, 1) + plural.substring(1, plural.length));
        this.plural(new RegExp("" + (plural.substring(0, 1)) + (plural.substring(1, plural.length)) + "$", "i"), plural.substring(0, 1) + plural.substring(1, plural.length));
        this.singular(new RegExp("" + (plural.substring(0, 1)) + (plural.substring(1, plural.length)) + "$", "i"), singular.substring(0, 1) + singular.substring(1, plural.length));
        return this.singular(new RegExp("" + (plural.substring(0, 1)) + (plural.substring(1, plural.length)) + "$", "i"), singular.substring(0, 1) + singular.substring(1, plural.length));
      }
    };

    Inflections.prototype.uncountable = function() {
      var words;
      words = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      this.uncountables.push(words);
      return this.uncountables = _.flatten(this.uncountables);
    };

    Inflections.prototype.human = function(rule, replacement) {
      return this.humans.unshift([rule, replacement]);
    };

    Inflections.prototype.clearInflections = function(scope) {
      if (scope == null) {
        scope = 'all';
      }
      return this[scope] = [];
    };

    Inflections.prototype.pluralize = function(word, count, options) {
      var ref, result;
      if (options == null) {
        options = {};
      }
      options = _.extend({
        plural: void 0,
        showNumber: true
      }, options);
      if (count !== void 0) {
        result = "";
        if (options.showNumber === true) {
          result += (count != null ? count : 0) + " ";
        }
        return result += count === 1 || (count != null ? typeof count.toString === "function" ? count.toString().match(/^1(\.0+)?$/) : void 0 : void 0) ? word : (ref = options.plural) != null ? ref : this.pluralize(word);
      } else {
        return this.apply_inflections(word, this.plurals);
      }
    };

    Inflections.prototype.singularize = function(word) {
      return this.apply_inflections(word, this.singulars);
    };

    Inflections.prototype.camelize = function(term, uppercase_first_letter) {
      if (uppercase_first_letter == null) {
        uppercase_first_letter = true;
      }
      if (uppercase_first_letter) {
        term = term.replace(/^[a-z\d]*/, (function(_this) {
          return function(a) {
            return _this.acronyms[a] || _.capitalize(a);
          };
        })(this));
      } else {
        term = term.replace(RegExp("^(?:" + this.acronym_matchers + "(?=\\b|[A-Z_])|\\w)"), function(a) {
          return a.toLowerCase();
        });
      }
      return term = term.replace(/(?:_|(\/))([a-z\d]*)/gi, (function(_this) {
        return function(match, $1, $2, idx, string) {
          $1 || ($1 = '');
          return "" + $1 + (_this.acronyms[$2] || _.capitalize($2));
        };
      })(this));
    };

    Inflections.prototype.underscore = function(camel_cased_word) {
      var word;
      word = camel_cased_word;
      word = word.replace(RegExp("(?:([A-Za-z\\d])|^)(" + this.acronym_matchers + ")(?=\\b|[^a-z])", "g"), function(match, $1, $2) {
        return "" + ($1 || '') + ($1 ? '_' : '') + ($2.toLowerCase());
      });
      word = word.replace(/([A-Z\d]+)([A-Z][a-z])/g, "$1_$2");
      word = word.replace(/([a-z\d])([A-Z])/g, "$1_$2");
      word = word.replace('-', '_');
      return word = word.toLowerCase();
    };

    Inflections.prototype.humanize = function(lower_case_and_underscored_word) {
      var human, i, len, ref, replacement, rule, word;
      word = lower_case_and_underscored_word;
      ref = this.humans;
      for (i = 0, len = ref.length; i < len; i++) {
        human = ref[i];
        rule = human[0];
        replacement = human[1];
        if (((rule.test != null) && rule.test(word)) || ((rule.indexOf != null) && word.indexOf(rule) >= 0)) {
          word = word.replace(rule, replacement);
          break;
        }
      }
      word = word.replace(/_id$/g, '');
      word = word.replace(/_/g, ' ');
      word = word.replace(/([a-z\d]*)/gi, (function(_this) {
        return function(match) {
          return _this.acronyms[match] || match.toLowerCase();
        };
      })(this));
      return word = _.trim(word).replace(/^\w/g, function(match) {
        return match.toUpperCase();
      });
    };

    Inflections.prototype.titleize = function(word) {
      return this.humanize(this.underscore(word)).replace(/([\s¿]+)([a-z])/g, function(match, boundary, letter, idx, string) {
        return match.replace(letter, letter.toUpperCase());
      });
    };

    Inflections.prototype.apply_inflections = function(word, rules) {
      var capture, i, len, match, regex, result, rule;
      if (!word) {
        return word;
      } else {
        result = word;
        match = result.toLowerCase().match(/\b\w+$/);
        if (match && _.indexOf(this.uncountables, match[0]) !== -1) {
          return result;
        } else {
          for (i = 0, len = rules.length; i < len; i++) {
            rule = rules[i];
            regex = rule[0], capture = rule[1];
            if (result.match(regex)) {
              result = result.replace(regex, capture);
              break;
            }
          }
          return result;
        }
      }
    };

    return Inflections;

  })();
  _.mixin(Strings.exports());
  return new Inflections;
});
