# BERTģ�ʹ�ѵ��������ȫ����





�ܹ�˵����
**BERTģ�ͷ����**
	����ģ�ͣ�����ʵʱԤ��ķ���
    ʹ�õ��� BERT-BiLSTM-CRF-NER 

**API�����** 
	����ʵʱԤ�����ΪӦ���ṩAPI�ӿڵķ�����flask��д�� 

**Ӧ�ö�**
	���յ�Ӧ�öˣ�
	������ʹ��һ��HTML��ҳ��ʵ�֣�


## �ؼ��ڵ�
��Ҫ�������¹ؼ��ڵ㣺
* ����׼��
* ģ��ѵ��
* ģ�͸�ʽת��
* ����˲���������
* API�����д�벿��
* �ͻ���(��ҳ�˵ı�д�벿��


## ����׼��


## ģ��ѵ��
ѵ��ģ�;�ֱ��ʹ��BERT�ķ��෽������ԭ����`run_classifier.py` ���Ƴ������޸�Ϊ `run_finance.py`������ѵ���Ĵ������Ϻܶ࣬�Ͳ�չ��˵���ˣ���Ҫ�����·�����

```python
#-----------------------------------------
#�ƾ��ǲƾ����ŷ������ݴ��� 2020/7/28 
#labels: 0�ǲƾ����� 1�ƾ�����
class SetimentProcessor(DataProcessor):
  def get_train_examples(self, data_dir):
    """See base class."""
    return self._create_examples(
        self._read_tsv(os.path.join(data_dir, "train.tsv")), "train")

  def get_dev_examples(self, data_dir):
    """See base class."""
    return self._create_examples(
        self._read_tsv(os.path.join(data_dir, "dev.tsv")), "dev")

  def get_test_examples(self, data_dir):
    """See base class."""
    return self._create_examples(
        self._read_tsv(os.path.join(data_dir, "test.tsv")), "test")

  def get_labels(self):
    """See base class."""

    """
    if not os.path.exists(os.path.join(FLAGS.output_dir, 'label_list.pkl')):
        with codecs.open(os.path.join(FLAGS.output_dir, 'label_list.pkl'), 'wb') as fd:
            pickle.dump(self.labels, fd)
    """
    return ["0", "1"]

  def _create_examples(self, lines, set_type):
    """Creates examples for the training and dev sets."""
    examples = []
    for (i, line) in enumerate(lines):
      if i == 0: 
        continue
      guid = "%s-%s" % (set_type, i)

      #debug
      #print("read line: No.%d" % i)

      text_a = tokenization.convert_to_unicode(line[1])
      if set_type == "test":
        label = "0"
      else:
        label = tokenization.convert_to_unicode(line[0])
      examples.append(
          InputExample(guid=guid, text_a=text_a, label=label))
    return examples
#-----------------------------------------
```
Ȼ������һ��������

```python
  processors = {
      "cola": ColaProcessor,
      "mnli": MnliProcessor,
      "mrpc": MrpcProcessor,
      "xnli": XnliProcessor,
      "setiment": SetimentProcessor,
  }
```

**�ر�˵��**��������һ��Ҫע�⣬�ں��ڲ����ʱ����Ҫһ��label2id���ֵ䣬����Ҫ��ѵ����ʱ��ͱ�����������`convert_single_example`�������������һ�Σ�

```python
  #--- save label2id.pkl ---
  #���������label2id.pkl
  output_label2id_file = os.path.join(FLAGS.output_dir, "label2id.pkl")
  if not os.path.exists(output_label2id_file):
    with open(output_label2id_file,'wb') as w:
      pickle.dump(label_map,w)

  #--- Add end ---
```

����ѵ����ͻ���������ļ��ˡ�

ʹ����������ѵ��ģ�ͣ�Ŀ¼��������ݸ��Ե�����޸ģ�

```shell
export BERT_BASE_DIR=/home/datawarehouse/bert_pretrained_model/chinese_L-12_H-768_A-12
export GLUE_DIR=./data
export TRAINED_CLASSIFIER=./output_0804
export EXP_NAME=

sudo python run_finance.py \
  --task_name=setiment \
  --do_train=true \
  --do_eval=true \
  --data_dir=$GLUE_DIR/$EXP_NAME \
  --vocab_file=$BERT_BASE_DIR/vocab.txt \
  --bert_config_file=$BERT_BASE_DIR/bert_config.json \
  --init_checkpoint=$BERT_BASE_DIR/bert_model.ckpt \
  --max_seq_length=128 \
  --train_batch_size=32 \
  --learning_rate=2e-5 \
  --num_train_epochs=5.0 \
  --output_dir=$TRAINED_CLASSIFIER/$EXP_NAME
```


����ʹ���������������Ԥ�⣺

```shell
python run_finance.py \
  --task_name=setiment \
  --do_predict=true \
  --data_dir=$GLUE_DIR/$EXP_NAME \
  --vocab_file=$BERT_BASE_DIR/vocab.txt \
  --bert_config_file=$BERT_BASE_DIR/bert_config.json \
  --init_checkpoint=$TRAINED_CLASSIFIER/$EXP_NAME \
  --max_seq_length=50 \
  --output_dir=$TRAINED_CLASSIFIER/$EXP_NAME

```


## ģ�͸�ʽת��

�����������Ѿ�ѵ���õ���ģ�ͣ������ģ����.ckpt���ļ���ʽ,�ļ��Ƚϴ󣬲����������ļ���

```
-rw-r--r-- 1 root root 1227239468 Apr 15 17:46 model.ckpt-759.data-00000-of-00001
-rw-r--r-- 1 root root      22717 Apr 15 17:46 model.ckpt-759.index
-rw-r--r-- 1 root root    3948381 Apr 15 17:46 model.ckpt-759.meta
```

���Կ�����ģ���ļ��ǳ��󣬴�Լ��1.17G��
����ʹ�õ�ģ�ͷ���ˣ�ʹ�õ���.pb��ʽ��ģ���ļ���������Ҫ�����ɵ�ckpt��ʽģ���ļ�ת����.pb��ʽ��ģ���ļ���
�������ṩ��һ��ת������:`freeze_graph.py`��ʹ�����£�

```shell
usage: freeze_graph.py [-h] -bert_model_dir BERT_MODEL_DIR -model_dir
                       MODEL_DIR [-model_pb_dir MODEL_PB_DIR]
                       [-max_seq_len MAX_SEQ_LEN] [-num_labels NUM_LABELS]
                       [-verbose]
```

����Ҫע��Ĳ����ǣ�

* `model_dir` ����ѵ���õ�.ckpt�ļ����ڵ�Ŀ¼
* `max_seq_len` Ҫ��ԭ��һ�£�
* `num_labels` �Ƿ����ǩ�ĸ���,��������3��


```shell
python freeze_graph.py \
    -bert_model_dir $BERT_BASE_DIR \
    -model_dir $TRAINED_CLASSIFIER/$EXP_NAME \
    -max_seq_len 50 \
    -num_labels 2


```

ִ�гɹ�����Կ�����`model_dir`Ŀ¼������һ��`classification_model.pb` �ļ���
תΪ.pb��ʽ��ģ���ļ���ͬʱҲ������Сģ���ļ��Ĵ�С,���Կ���ת�����ģ���ļ���Լ��390M��

```
-rw-rw-r-- 1 hexi hexi 409326375 Apr 15 17:58 classification_model.pb
```

## ����˲���������

���ڿ��԰�װ������ˣ�ʹ�õ��� bert-base, ��������Ŀ`BERT-BiLSTM-CRF-NER`, �����ֻ�Ǹ���Ŀ�е�һ�����֡�
��Ŀ��ַ��[https://github.com/macanv/BERT-BiLSTM-CRF-NER](https://github.com/macanv/BERT-BiLSTM-CRF-NER) ����лMacanvͬѧ�ṩ��ô�õ���Ŀ��

����Ҫ˵��һ�£����Ǿ����ῴ��bert-as-service �����Ŀ�Ľ��ܣ���ֻ�ܼ���BERT��Ԥѵ��ģ�ͣ�����ı��������Ľ����
�����Ҫ����fine-turing���ģ�ͣ���Ҫ�õ� bert-base �ˣ����������
[����BERTԤѵ������������ʵ��ʶ��TensorFlowʵ��](https://blog.csdn.net/macanv/article/details/85684284)


���ش��벢��װ ��
```shell
pip install bert-base==0.0.7 -i https://pypi.python.org/simple
```
���� 

```shell
git clone https://github.com/macanv/BERT-BiLSTM-CRF-NER
cd BERT-BiLSTM-CRF-NER/
python3 setup.py install
```


ʹ�� bert-base ����������ģʽ���ֱ�֧������ģ�ͣ�ʹ�ò���`-mode` ��ָ����
+ NER      ���б�ע���ͣ���������ʵ��ʶ��
+ CLASS    ����ģ�ͣ����Ǳ�����ʹ�õ�ģ��
+ BERT     ������Ǹ�bert-as-service һ����ģʽ��

֮����Ҫ�ֳɲ�ͬ������ģʽ������Ϊ��ͬģ�Ͷ��������ݵ�Ԥ�����ǲ�ͬ�ģ�����ʵ��ʶ��NER��Ҫ�������б�ע��
������ģ��ֻҪ����label�Ϳ����ˡ�


��װ������з���ͬʱָ������ HTTP 8091�˿ڣ���ʹ��GPU 1���ܣ�

```shell
export BERT_BASE_DIR=/home/datawarehouse/bert_pretrained_model/chinese_L-12_H-768_A-12
export TRAINED_CLASSIFIER=./output_0804
export EXP_NAME=

bert-base-serving-start \
    -model_dir $TRAINED_CLASSIFIER/$EXP_NAME \
    -bert_model_dir $BERT_BASE_DIR \
    -model_pb_dir $TRAINED_CLASSIFIER/$EXP_NAME \
    -mode CLASS \
    -max_seq_len 50 \
    -http_port 8091 \
    -port 5575 \
    -port_out 5576 \
    -device_map -1

```
**ע��**��port �� port_out ������������API���õĶ˿ںţ�
Ĭ����5555��5556,�����׼��������ģ�ͷ���ʵ������һ��Ҫָ���Լ��Ķ˿ںţ������ͻ��
�������Ǹ�Ϊ�� 5575 �� 5576

�������û������������������Щģ��ûװ��,���� bert_base/server/http.py�����õģ�װ�Ͼͺ��ˣ�

```
sudo pip install flask 
sudo pip install flask_compress
sudo pip install flask_cors
sudo pip install flask_json
```

�������������2��GTX 1080 Ti�����ʱ��˫�����������ڷ��ӳ����ˣ�GPU 1����Ԥ�⣬GPU 0�����Լ���ѵ��ģ�͡�

���з������Զ����ɺܶ���ʱ��Ŀ¼���ļ���Ϊ�˷���������������ɽ���һ������Ŀ¼��������������д��һ��shell�ű���
���ﴴ������`finance_svr\bertsvr.sh` ���������ԱȽϷ�������÷���������ʱ�Զ�������������������ÿ������ʱ�Զ������ʱ�ļ�

�������£�

```shell
#!/bin/bash
#chkconfig: 2345 80 90
#description: ����BERT����ģ�� 

echo '�������� BERT finance svr...'
cd /mnt/sda1/transdat/bert-demo/bert/finance_svr
sudo rm -rf tmp*

export BERT_BASE_DIR=/mnt/sda1/transdat/bert-demo/bert/chinese_L-12_H-768_A-12
export TRAINED_CLASSIFIER=/mnt/sda1/transdat/bert-demo/bert/output
export EXP_NAME=finance_0

bert-base-serving-start \
    -model_dir $TRAINED_CLASSIFIER/$EXP_NAME \
    -bert_model_dir $BERT_BASE_DIR \
    -model_pb_dir $TRAINED_CLASSIFIER/$EXP_NAME \
    -mode CLASS \
    -max_seq_len 128 \
    -http_port 8091 \
    -port 5575 \
    -port_out 5576 \
    -device_map 1 

```

����˵��һ���ڴ��ʹ�������
BERT��ѵ��ʱ��Ҫ����������ģ�����ݣ�Ҫ�õ��ڴ��ǱȽ϶�ģ����Ҫ10G���������õ���GTX 1080 Ti 11G��
����ѵ����󣬰�����ķ�ʽ�������pbģ���ļ�ʱ���Ͳ���Ҫ��ô���ˣ�����Ҳ���Կ���pbģ���ļ�����390M��
��ʵֻҪ��ʹ�õ���BERT base Ԥѵ��ģ�ͣ����յĵõ���pb�ļ���С���ǲ��ġ�

����ͬѧ�ʵ��ܲ�����CPU������������û���Թ���������϶��ǿ��Եģ�ֻ���ڼ����ٶ��ϸ�GPU���в��

������ʹ��GPU 1��ʵʱԤ�⣬ͬʱ������2��BERTģ��,��ͼ����:

![GPU��ͼ](https://github.com/xmxoxo/BERT-train2deploy/blob/master/images/cap02.png?raw=true)


### �˿ڲ���

ģ�ͷ���˲�������ˣ�����ʹ��curl����������һ���������������

```shell
curl -X POST http://192.168.15.111:8091/encode \
  -H 'content-type: application/json' \
  -d '{"id": 111,"texts": ["ͻ��������һ���Ů����ײ���������أ�","����������ӿ�չ�Ի������ж�"], "is_tokenized": false}'

```

ִ�н����
```
>   -H 'content-type: application/json' \
>   -d '{"id": 111,"texts": ["ͻ��������һ���Ů����ײ���������أ�","����������ӿ�չ�Ի������ж�"], "is_tokenized": false}'
{"id":111,"result":[{"pred_label":["1","-1"],"score":[0.9974544644355774,0.9961422085762024]}],"status":200}

```
���Կ�����Ӧ���������ۣ�Ԥ����һ����1����һ����-1��������ٶȻ��Ƿǳ��ܿ�ġ�
ͨ�����ַ�ʽ�����û��ǲ�̫���㣬֪�������ͨѶ��ʽ�����ǿ�����flask��дһ��API����
Ϊ���е�Ӧ��ͳһ�ṩ����


## API�����д�벿��

Ϊ�˷���ͻ��˵ĵ��ã�ͬʱҲΪ�˿��ԶԶ��������Ԥ�⣬������flask��дһ��API����ˣ�ʹ�ø����ķ�ʽ����ͻ��ˣ�Ӧ�ã���ͨѶ��
����API����˷��ڶ���Ŀ¼`/finance_apisvr/`Ŀ¼�¡�

��flask��������˲�����������,�����в������£�

```python
def main_cli ():
    pass
    parser = argparse.ArgumentParser(description='API demo server')
    parser.add_argument('-ip', type=str, default="0.0.0.0",
                        help='chinese google bert model serving')
    parser.add_argument('-port', type=int, default=8910,
                        help='listen port,default:8910')

    args = parser.parse_args()

    flask_server(args)

```

�������ﴴ��APP����

```python

    app.run(
        host = args.ip,     #'0.0.0.0',
        port = args.port,   #8910,  
        debug = True 
    )

```

����Ľӿڼ򵥹滮Ϊ`/api/v0.1/query`, ʹ��POST������������Ϊ'text'��ʹ��JSON���ؽ����
·������:

```python
@app.route('/api/v0.1/query', methods=['POST'])
```

API����˵ĺ��ķ���������BERT-Serving����ͨѶ����Ҫ����һ���ͻ���BertClient��

```python
#�Ծ��ӽ���Ԥ��ʶ��
def class_pred(list_text):
    #�ı���ֳɾ���
    #list_text = cut_sent(text)
    print("total setance: %d" % (len(list_text)) )
    with BertClient(ip='192.168.15.111', port=5575, port_out=5576, show_server_config=False, check_version=False, check_length=False,timeout=10000 ,  mode='CLASS') as bc:
        start_t = time.perf_counter()
        rst = bc.encode(list_text)
        print('result:', rst)
        print('time used:{}'.format(time.perf_counter() - start_t))
    #���ؽṹΪ��
    # rst: [{'pred_label': ['0', '1', '0'], 'score': [0.9983683228492737, 0.9988993406295776, 0.9997349381446838]}]
    #��ȡ����ע���
    pred_label = rst[0]["pred_label"]
    result_txt = [ [pred_label[i],list_text[i] ] for i in range(len(pred_label))]
    return result_txt

```
ע�⣺�����IP���˿�Ҫ�����˵Ķ�Ӧ��

����API ����ˣ�

```shell
python api_service.py
```
�ڴ����е�debug����ΪTrue������ֻҪ�����ļ�������ͻ��Զ������������ȽϷ�����ԡ�
���н�ͼ���£�

![API�����](https://github.com/xmxoxo/BERT-train2deploy/blob/master/images/cap00.png?raw=true)


����һ��Ҳ����ʹ��curl�����������߽��в��ԣ�Ҳ���Ե������ҳ�ͻ��˺�һ�����ԡ�
������ʹ��chrome��� API-debug�����в��ԣ�����ͼ��

![API����](https://github.com/xmxoxo/BERT-train2deploy/blob/master/images/cap01.png?raw=true)




## �ͻ���(��ҳ�ˣ�

����ʹ��һ��HTMLҳ����ģ��ͻ��ˣ���ʵ����Ŀ�п����Ǿ����Ӧ�á�
Ϊ�˷�����ʾ�Ͱ���ҳģ����API����˺ϲ���һ���ˣ�����ҳ��ʹ��AJAX����API�����ͨѶ��

����ģ��Ŀ¼`templates`��ʹ��ģ��������һ��HTML,ģ���ļ���Ϊ`index.html`��
��HTMLҳ����ʹ��AJAX�����ýӿ�,��������ͬһ����������ͬһ���˿ڣ���ֱַ����`/api/v0.1/query`�Ϳ����ˣ�
��ʵ����Ŀ�У��ͻ�Ӧ�ö���API�Ƿֿ��ģ�����Ҫָ���ӿ�URL��ַ��ͬʱ��Ҫע�����ݰ�ȫ�ԡ�
�������£�

```Javascript
function UrlPOST(txt,myfun){
	if (txt=="")
	{
		return "error parm"; 
	}
	var httpurl = "/api/v0.1/query"; 
	$.ajax({
			type: "POST",
			data: "text="+txt,
			url: httpurl,
			//async:false,
			success: function(data)
			{   
				myfun(data);
			}
	});
}

```

����API����˺󣬿���ʹ��`IP+�˿�`�������ˣ�����ĵ�ַ��`http://192.168.15.111:8910/`


���н����ͼ���£�

![���н����ͼ](https://github.com/xmxoxo/BERT-train2deploy/blob/master/images/cap05.png?raw=true)

���Կ����������ʱʱ��Ϊ37ms���ٶȻ��Ǻܿ�ģ���Ȼ����ٶȸ�Ӳ�������йء�


## �ο�����:
+ [https://github.com/google-research/bert](https://github.com/google-research/bert)
      
+ [https://github.com/hanxiao/bert-as-service](https://github.com/hanxiao/bert-as-service)

+ [https://github.com/macanv/BERT-BiLSTM-CRF-NER](https://github.com/macanv/BERT-BiLSTM-CRF-NER)

