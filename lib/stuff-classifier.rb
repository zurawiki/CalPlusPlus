module StuffClassifier
  autoload :Storage, 'stuff-classifier/storage'
  autoload :InMemoryStorage, 'stuff-classifier/storage'
  autoload :FileStorage, 'stuff-classifier/storage'

  autoload :Tokenizer, 'stuff-classifier/tokenizer'

  autoload :Base, 'stuff-classifier/base'
  autoload :Bayes, 'stuff-classifier/bayes'
  autoload :Multi, 'stuff-classifier/multi'

end
