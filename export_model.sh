python export_model.py \
  --bert_config_file=./chinese_L-12_H-768_A-12/bert_config.json \
  --init_checkpoint=./output/ \
  --output_dir=./output/ \
  --export_dir=./output/export/ \
  --num_labels=2 \
  --max_seq_length=128
