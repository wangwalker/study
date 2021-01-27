import re
import pylru

"""
A abstract class for search engine
"""
class SearchEngineBase(object):
    def __init__(self):
        pass

    def add_corpus(self, file_path):
        with open(file_path, 'r') as fin:
            text = fin.read()
        self.process_corpus(file_path, text)

    def process_corpus(self, id, text):
        raise Exception('process_corpus not implemented.')

    def search(self, query):
        raise Exception('search not implemented.')

def main(search_engine):
    file_paths = [f"data/se{n}.txt" for n in range(1, 5)]
    for file_path in file_paths:
        search_engine.add_corpus(file_path)
    
    while True:
        query = input("Please input you query:")
        results = search_engine.search(query)
        print('found {} results:'.format(len(results)))
        for result in results:
            print(result)

"""
A simple search engine just using existence
"""
class SimpleEngine(SearchEngineBase):
    def __init__(self):
        super(SimpleEngine, self).__init__()
        self.__id_to_texts = {}
    
    def process_corpus(self, id, text):
        self.__id_to_texts[id] = text

    def search(self, query):
        results = []
        for id, text in self.__id_to_texts.items():
            if query in text:
                results.append(id)
        return results

"""
A search engine of bag of words model
"""
class BOWEngine(SearchEngineBase):
    def __init__(self):
        super(BOWEngine, self).__init__()
        self.__id_to_words = {}

    def process_corpus(self, id, text):
        self.__id_to_words[id] = self.parse_text_to_words(text)

    def search(self, query):
        query_words = self.parse_text_to_words(query)
        results = []
        for id, words in self.__id_to_words.items():
            if self.query_match(query_words, words):
                results.append(id)
        return results

    @staticmethod
    def query_match(query_words, words):
        for query_word in query_words:
            if query_word not in words:
                return False
        return True

    @staticmethod
    def parse_text_to_words(text):
        # 1. 去除标点符号和换行符
        text = re.sub(r'[^\w]', ' ', text)
        # 2. 转小写
        text = text.lower()
        # 3. 拆成单词
        word_list = text.split(' ')
        # 4. 去除空值
        word_list = filter(None, word_list)
        # 用set去除重复值
        return set(word_list)

"""
A search engine of bag of word and inverted index model
"""
class BOWInvertedIndexEngine(SearchEngineBase):
    def __init__(self):
        super(BOWInvertedIndexEngine, self).__init__()
        self.inverted_index = {}

    def process_corpus(self, id, text):
        words = self.parse_text_to_words(text)
        for word in words:
            if word not in self.inverted_index:
                self.inverted_index[word] = []
            self.inverted_index[word].append(id)

    def search(self, query):
        query_words = self.parse_text_to_words(query)
        query_words_index = list()
        for query_word in query_words:
            query_words_index.append(0)

        # 如果某个关键字的倒排索引为空，则立刻返回
        for query_word in query_words:
            if query_word not in self.inverted_index:
                return []

        results = []
        
        while True:
            
            # 1. 获取当前状态下所有倒排索引的index
            current_ids = []

            for idx, query_word in enumerate(query_words):
                current_index = query_words_index[idx]
                current_inverted_list = self.inverted_index[query_word]

                # 2. 如果已经遍历到最后一个索引，则结束查找
                if current_index >= len(current_inverted_list):
                    return results

                current_ids.append(current_inverted_list[current_index])

            # 3. 如果current_ids中的所有元素一样，则表明当前关键字出现在了所有文档中
            if all(x == current_ids[0] for x in current_ids):
                results.append(current_ids[0])
                query_words_index = [x + 1 for x in query_words_index]

            # 4. 如果不是，则把最小的元素加1
            min_val = min(current_ids)
            min_val_pos = current_ids.index(min_val)
            query_words_index[min_val_pos] += 1

    @staticmethod
    def parse_text_to_words(text):
        # 1. 去除标点符号和换行符
        text = re.sub(r'[^\w]', ' ', text)
        # 2. 转小写
        text = text.lower()
        # 3. 拆成单词
        word_list = text.split(' ')
        # 4. 去除空值
        word_list = filter(None, word_list)
        # 用set去除重复值
        return set(word_list)
    
class LRUCache(object):
    def __init__(self, size=32):
        self.cache = pylru.lrucache(size=size)

    def has(self, key):
        return key in self.cache

    def get(self, key):
        return self.cache[key]

    def set(self, key, value):
        self.cache[key] = value

class BOWInvertedIndexEngineWithCache(BOWInvertedIndexEngine, LRUCache):
    def __init__(self):
        super(BOWInvertedIndexEngineWithCache, self).__init__()
        LRUCache.__init__(self)

    def search(self, query):
        if self.has(query):
            print('cache hit!')
            return self.get(query)

        result = super(BOWInvertedIndexEngineWithCache, self).search(query)
        self.set(query, result)

        return result

search_engine = BOWInvertedIndexEngineWithCache()
main(search_engine)