# Step55 最终统计显著性闭环报告

本报告读取 Step54 的最终 PER lookup 综合证据，不重新运行仿真，不调整主方法参数。

## 1. 输入覆盖率摘要

| Method | Cases | Min raw seeds | Min stage seeds |
|---|---:|---:|---:|
| Link-delay-aware | 16 | 50 | 50 |
| Confidence-heuristic | 16 | 50 | 50 |
| Risk-constrained-v6 | 16 | 50 | 50 |
| Constrained Oracle | 16 | 50 | 50 |
| DCC-like | 16 | 50 | 50 |
| AoI-aware | 16 | 50 | 50 |

## 2. 论文主结果表格式：mean ± 95% CI

| Scene | Config | Method | Timely | Emergency timely | Loss | Delay | Tx cost |
|---|---|---|---:|---:|---:|---:|---:|
| 10014 | Default | Link-delay-aware | 0.9346 ± 0.0022 | 0.9833 ± 0.0140 | 0.0654 ± 0.0022 | 0.03632 ± 0.00072 | 1.6295 ± 0.0000 |
| 10014 | Default | Confidence-heuristic | 0.9884 ± 0.0012 | 1.0000 ± 0.0000 | 0.0116 ± 0.0012 | 0.02044 ± 0.00049 | 2.0926 ± 0.0107 |
| 10014 | Default | Risk-constrained-v6 | 0.9918 ± 0.0010 | 1.0000 ± 0.0000 | 0.0082 ± 0.0010 | 0.01735 ± 0.00033 | 2.0006 ± 0.0086 |
| 10014 | Default | Constrained Oracle | 0.9961 ± 0.0006 | 0.9833 ± 0.0140 | 0.0039 ± 0.0006 | 0.01847 ± 0.00022 | 2.1027 ± 0.0069 |
| 10014 | Default | DCC-like | 0.9799 ± 0.0015 | 1.0000 ± 0.0000 | 0.0201 ± 0.0015 | 0.03858 ± 0.00060 | 4.0730 ± 0.0007 |
| 10014 | Default | AoI-aware | 0.9770 ± 0.0016 | 0.8633 ± 0.0381 | 0.0230 ± 0.0016 | 0.02273 ± 0.00041 | 2.1993 ± 0.0000 |
| 10014 | ForestGeometry | Link-delay-aware | 0.7876 ± 0.0013 | 0.0233 ± 0.0209 | 0.2123 ± 0.0013 | 0.08490 ± 0.00055 | 1.6983 ± 0.0000 |
| 10014 | ForestGeometry | Confidence-heuristic | 0.7891 ± 0.0014 | 0.0200 ± 0.0178 | 0.2107 ± 0.0014 | 0.08468 ± 0.00055 | 2.0880 ± 0.0156 |
| 10014 | ForestGeometry | Risk-constrained-v6 | 0.7994 ± 0.0014 | 0.0233 ± 0.0209 | 0.2005 ± 0.0014 | 0.08017 ± 0.00054 | 2.2843 ± 0.0132 |
| 10014 | ForestGeometry | Constrained Oracle | 0.8023 ± 0.0015 | 0.0200 ± 0.0178 | 0.1977 ± 0.0016 | 0.07964 ± 0.00051 | 2.4153 ± 0.0118 |
| 10014 | ForestGeometry | DCC-like | 0.7998 ± 0.0006 | 0.0100 ± 0.0111 | 0.2001 ± 0.0006 | 0.09426 ± 0.00023 | 3.8687 ± 0.0000 |
| 10014 | ForestGeometry | AoI-aware | 0.7933 ± 0.0015 | 0.0167 ± 0.0168 | 0.2067 ± 0.0015 | 0.08352 ± 0.00059 | 2.3691 ± 0.0000 |
| 10006 | Default | Link-delay-aware | 0.9310 ± 0.0026 | 0.9907 ± 0.0014 | 0.0689 ± 0.0026 | 0.04102 ± 0.00099 | 2.2032 ± 0.0000 |
| 10006 | Default | Confidence-heuristic | 0.9882 ± 0.0012 | 0.9951 ± 0.0010 | 0.0111 ± 0.0012 | 0.02228 ± 0.00038 | 2.7255 ± 0.0039 |
| 10006 | Default | Risk-constrained-v6 | 0.9900 ± 0.0008 | 0.9951 ± 0.0010 | 0.0093 ± 0.0008 | 0.02400 ± 0.00026 | 2.8490 ± 0.0021 |
| 10006 | Default | Constrained Oracle | 0.9952 ± 0.0006 | 0.9962 ± 0.0010 | 0.0038 ± 0.0006 | 0.02239 ± 0.00020 | 2.7322 ± 0.0012 |
| 10006 | Default | DCC-like | 0.9184 ± 0.0024 | 0.9955 ± 0.0010 | 0.0813 ± 0.0025 | 0.07075 ± 0.00095 | 4.4674 ± 0.0000 |
| 10006 | Default | AoI-aware | 0.9720 ± 0.0015 | 0.9897 ± 0.0013 | 0.0269 ± 0.0015 | 0.02795 ± 0.00048 | 2.3713 ± 0.0007 |
| 10006 | ForestGeometry | Link-delay-aware | 0.7069 ± 0.0012 | 0.7999 ± 0.0011 | 0.2921 ± 0.0012 | 0.08836 ± 0.00031 | 2.2646 ± 0.0000 |
| 10006 | ForestGeometry | Confidence-heuristic | 0.7079 ± 0.0012 | 0.7999 ± 0.0009 | 0.2902 ± 0.0013 | 0.08823 ± 0.00032 | 2.6148 ± 0.0102 |
| 10006 | ForestGeometry | Risk-constrained-v6 | 0.7131 ± 0.0014 | 0.7999 ± 0.0011 | 0.2859 ± 0.0014 | 0.08610 ± 0.00038 | 2.8988 ± 0.0049 |
| 10006 | ForestGeometry | Constrained Oracle | 0.7138 ± 0.0013 | 0.7995 ± 0.0009 | 0.2852 ± 0.0013 | 0.08639 ± 0.00034 | 2.7448 ± 0.0082 |
| 10006 | ForestGeometry | DCC-like | 0.7089 ± 0.0007 | 0.7984 ± 0.0007 | 0.2907 ± 0.0008 | 0.10863 ± 0.00018 | 4.1592 ± 0.0000 |
| 10006 | ForestGeometry | AoI-aware | 0.7119 ± 0.0014 | 0.7986 ± 0.0011 | 0.2851 ± 0.0014 | 0.08701 ± 0.00038 | 2.6525 ± 0.0000 |
| 10011 | Default | Link-delay-aware | 0.9928 ± 0.0009 | 1.0000 ± 0.0000 | 0.0072 ± 0.0009 | 0.01342 ± 0.00017 | 1.7188 ± 0.0000 |
| 10011 | Default | Confidence-heuristic | 0.9939 ± 0.0009 | 1.0000 ± 0.0000 | 0.0061 ± 0.0009 | 0.01325 ± 0.00017 | 1.9593 ± 0.0103 |
| 10011 | Default | Risk-constrained-v6 | 0.9951 ± 0.0006 | 1.0000 ± 0.0000 | 0.0049 ± 0.0006 | 0.01306 ± 0.00014 | 1.8882 ± 0.0091 |
| 10011 | Default | Constrained Oracle | 0.9987 ± 0.0004 | 1.0000 ± 0.0000 | 0.0013 ± 0.0004 | 0.01297 ± 0.00012 | 1.9434 ± 0.0076 |
| 10011 | Default | DCC-like | 1.0000 ± 0.0001 | 1.0000 ± 0.0000 | 0.0000 ± 0.0001 | 0.02037 ± 0.00005 | 3.6240 ± 0.0000 |
| 10011 | Default | AoI-aware | 0.9932 ± 0.0009 | 0.9970 ± 0.0033 | 0.0068 ± 0.0009 | 0.01398 ± 0.00017 | 1.8355 ± 0.0000 |
| 10011 | ForestGeometry | Link-delay-aware | 0.6730 ± 0.0035 | 0.4510 ± 0.0253 | 0.3240 ± 0.0036 | 0.13465 ± 0.00106 | 2.3561 ± 0.0002 |
| 10011 | ForestGeometry | Confidence-heuristic | 0.7609 ± 0.0025 | 0.4840 ± 0.0250 | 0.2359 ± 0.0026 | 0.10913 ± 0.00074 | 3.0044 ± 0.0170 |
| 10011 | ForestGeometry | Risk-constrained-v6 | 0.8019 ± 0.0030 | 0.4850 ± 0.0275 | 0.1919 ± 0.0030 | 0.09187 ± 0.00099 | 3.2240 ± 0.0205 |
| 10011 | ForestGeometry | Constrained Oracle | 0.7902 ± 0.0026 | 0.4770 ± 0.0276 | 0.2020 ± 0.0025 | 0.09983 ± 0.00075 | 3.5085 ± 0.0104 |
| 10011 | ForestGeometry | DCC-like | 0.6075 ± 0.0031 | 0.3920 ± 0.0268 | 0.3903 ± 0.0031 | 0.16166 ± 0.00092 | 2.9618 ± 0.0002 |
| 10011 | ForestGeometry | AoI-aware | 0.8046 ± 0.0028 | 0.3270 ± 0.0212 | 0.1941 ± 0.0028 | 0.08875 ± 0.00090 | 4.0374 ± 0.0014 |
| 10019 | Default | Link-delay-aware | 0.9999 ± 0.0001 | 1.0000 ± 0.0000 | 0.0001 ± 0.0001 | 0.01210 ± 0.00003 | 2.4997 ± 0.0000 |
| 10019 | Default | Confidence-heuristic | 0.9999 ± 0.0001 | 1.0000 ± 0.0000 | 0.0001 ± 0.0001 | 0.01210 ± 0.00003 | 2.9805 ± 0.0036 |
| 10019 | Default | Risk-constrained-v6 | 0.9999 ± 0.0001 | 1.0000 ± 0.0000 | 0.0001 ± 0.0001 | 0.01210 ± 0.00003 | 3.0448 ± 0.0000 |
| 10019 | Default | Constrained Oracle | 0.9999 ± 0.0001 | 1.0000 ± 0.0000 | 0.0001 ± 0.0001 | 0.01210 ± 0.00003 | 2.5081 ± 0.0019 |
| 10019 | Default | DCC-like | 1.0000 ± 0.0000 | 1.0000 ± 0.0000 | 0.0000 ± 0.0000 | 0.03680 ± 0.00008 | 4.5807 ± 0.0000 |
| 10019 | Default | AoI-aware | 0.9979 ± 0.0004 | 0.9979 ± 0.0005 | 0.0021 ± 0.0004 | 0.01282 ± 0.00004 | 1.6874 ± 0.0000 |
| 10019 | ForestGeometry | Link-delay-aware | 0.6250 ± 0.0023 | 0.5873 ± 0.0025 | 0.3414 ± 0.0024 | 0.03987 ± 0.00006 | 2.8420 ± 0.0000 |
| 10019 | ForestGeometry | Confidence-heuristic | 0.6245 ± 0.0018 | 0.5868 ± 0.0020 | 0.3204 ± 0.0030 | 0.04039 ± 0.00007 | 3.3406 ± 0.0164 |
| 10019 | ForestGeometry | Risk-constrained-v6 | 0.6178 ± 0.0022 | 0.5795 ± 0.0024 | 0.3141 ± 0.0022 | 0.04090 ± 0.00008 | 3.3230 ± 0.0010 |
| 10019 | ForestGeometry | Constrained Oracle | 0.6124 ± 0.0021 | 0.5736 ± 0.0023 | 0.3121 ± 0.0025 | 0.04124 ± 0.00007 | 3.0000 ± 0.0122 |
| 10019 | ForestGeometry | DCC-like | 0.6121 ± 0.0022 | 0.5730 ± 0.0024 | 0.3756 ± 0.0024 | 0.05675 ± 0.00006 | 3.7790 ± 0.0000 |
| 10019 | ForestGeometry | AoI-aware | 0.6261 ± 0.0021 | 0.5886 ± 0.0023 | 0.3089 ± 0.0023 | 0.04098 ± 0.00007 | 3.3155 ± 0.0000 |
| 10017 | Default | Link-delay-aware | 0.8682 ± 0.0035 | 0.9317 ± 0.0105 | 0.1318 ± 0.0035 | 0.05308 ± 0.00107 | 2.0472 ± 0.0001 |
| 10017 | Default | Confidence-heuristic | 0.9773 ± 0.0017 | 0.9811 ± 0.0078 | 0.0226 ± 0.0016 | 0.02857 ± 0.00039 | 2.9820 ± 0.0100 |
| 10017 | Default | Risk-constrained-v6 | 0.9790 ± 0.0016 | 0.9811 ± 0.0078 | 0.0209 ± 0.0016 | 0.02970 ± 0.00039 | 2.8695 ± 0.0087 |
| 10017 | Default | Constrained Oracle | 0.9890 ± 0.0012 | 0.9728 ± 0.0099 | 0.0109 ± 0.0012 | 0.02919 ± 0.00027 | 3.2205 ± 0.0074 |
| 10017 | Default | DCC-like | 0.8942 ± 0.0026 | 0.9933 ± 0.0033 | 0.1056 ± 0.0027 | 0.06984 ± 0.00082 | 4.7276 ± 0.0002 |
| 10017 | Default | AoI-aware | 0.9486 ± 0.0024 | 0.9422 ± 0.0096 | 0.0513 ± 0.0024 | 0.03207 ± 0.00040 | 3.3290 ± 0.0006 |
| 10017 | ForestGeometry | Link-delay-aware | 0.5236 ± 0.0011 | 0.0244 ± 0.0076 | 0.4757 ± 0.0011 | 0.12745 ± 0.00021 | 2.1792 ± 0.0000 |
| 10017 | ForestGeometry | Confidence-heuristic | 0.5264 ± 0.0014 | 0.0244 ± 0.0076 | 0.4728 ± 0.0014 | 0.12704 ± 0.00025 | 2.6790 ± 0.0216 |
| 10017 | ForestGeometry | Risk-constrained-v6 | 0.5326 ± 0.0016 | 0.0244 ± 0.0076 | 0.4667 ± 0.0016 | 0.12483 ± 0.00037 | 3.0038 ± 0.0241 |
| 10017 | ForestGeometry | Constrained Oracle | 0.5387 ± 0.0018 | 0.0228 ± 0.0071 | 0.4611 ± 0.0018 | 0.12499 ± 0.00040 | 3.7640 ± 0.0128 |
| 10017 | ForestGeometry | DCC-like | 0.5212 ± 0.0008 | 0.0217 ± 0.0059 | 0.4784 ± 0.0008 | 0.14317 ± 0.00019 | 4.0393 ± 0.0000 |
| 10017 | ForestGeometry | AoI-aware | 0.5374 ± 0.0017 | 0.0306 ± 0.0072 | 0.4606 ± 0.0017 | 0.12483 ± 0.00038 | 4.0994 ± 0.0000 |
| 10013 | Default | Link-delay-aware | 0.9922 ± 0.0009 | 0.9997 ± 0.0002 | 0.0078 ± 0.0009 | 0.01343 ± 0.00015 | 2.4988 ± 0.0000 |
| 10013 | Default | Confidence-heuristic | 0.9924 ± 0.0009 | 1.0000 ± 0.0000 | 0.0076 ± 0.0009 | 0.01342 ± 0.00015 | 2.9676 ± 0.0028 |
| 10013 | Default | Risk-constrained-v6 | 0.9924 ± 0.0009 | 1.0000 ± 0.0000 | 0.0076 ± 0.0009 | 0.01342 ± 0.00015 | 3.0428 ± 0.0000 |
| 10013 | Default | Constrained Oracle | 0.9964 ± 0.0008 | 0.9997 ± 0.0002 | 0.0036 ± 0.0008 | 0.01279 ± 0.00013 | 2.5384 ± 0.0018 |
| 10013 | Default | DCC-like | 0.9999 ± 0.0001 | 1.0000 ± 0.0000 | 0.0001 ± 0.0001 | 0.04051 ± 0.00009 | 4.6047 ± 0.0000 |
| 10013 | Default | AoI-aware | 0.9869 ± 0.0011 | 0.9935 ± 0.0008 | 0.0131 ± 0.0011 | 0.01427 ± 0.00016 | 1.6868 ± 0.0000 |
| 10013 | ForestGeometry | Link-delay-aware | 0.5587 ± 0.0024 | 0.6146 ± 0.0025 | 0.4054 ± 0.0025 | 0.05659 ± 0.00009 | 2.9715 ± 0.0000 |
| 10013 | ForestGeometry | Confidence-heuristic | 0.5574 ± 0.0027 | 0.6130 ± 0.0028 | 0.4031 ± 0.0031 | 0.05667 ± 0.00011 | 3.2768 ± 0.0138 |
| 10013 | ForestGeometry | Risk-constrained-v6 | 0.5528 ± 0.0020 | 0.6077 ± 0.0021 | 0.3822 ± 0.0027 | 0.05750 ± 0.00010 | 3.4816 ± 0.0152 |
| 10013 | ForestGeometry | Constrained Oracle | 0.5488 ± 0.0023 | 0.6001 ± 0.0023 | 0.3767 ± 0.0026 | 0.05763 ± 0.00014 | 3.4707 ± 0.0080 |
| 10013 | ForestGeometry | DCC-like | 0.5441 ± 0.0021 | 0.5992 ± 0.0023 | 0.4453 ± 0.0021 | 0.07083 ± 0.00008 | 3.4012 ± 0.0000 |
| 10013 | ForestGeometry | AoI-aware | 0.5538 ± 0.0025 | 0.6072 ± 0.0026 | 0.3944 ± 0.0029 | 0.05727 ± 0.00011 | 3.4274 ± 0.0000 |
| 10007 | Default | Link-delay-aware | 0.9562 ± 0.0020 | 1.0000 ± 0.0000 | 0.0438 ± 0.0020 | 0.03095 ± 0.00072 | 2.2573 ± 0.0000 |
| 10007 | Default | Confidence-heuristic | 0.9951 ± 0.0007 | 1.0000 ± 0.0000 | 0.0049 ± 0.0007 | 0.01973 ± 0.00023 | 2.7495 ± 0.0043 |
| 10007 | Default | Risk-constrained-v6 | 0.9957 ± 0.0006 | 1.0000 ± 0.0000 | 0.0043 ± 0.0006 | 0.02112 ± 0.00018 | 2.8292 ± 0.0023 |
| 10007 | Default | Constrained Oracle | 0.9970 ± 0.0006 | 1.0000 ± 0.0000 | 0.0030 ± 0.0006 | 0.02111 ± 0.00021 | 2.6836 ± 0.0033 |
| 10007 | Default | DCC-like | 0.9268 ± 0.0021 | 1.0000 ± 0.0000 | 0.0732 ± 0.0021 | 0.06590 ± 0.00079 | 4.8318 ± 0.0000 |
| 10007 | Default | AoI-aware | 0.9779 ± 0.0012 | 0.9993 ± 0.0004 | 0.0221 ± 0.0012 | 0.02620 ± 0.00043 | 2.2981 ± 0.0000 |
| 10007 | ForestGeometry | Link-delay-aware | 0.8516 ± 0.0016 | 1.0000 ± 0.0000 | 0.1484 ± 0.0016 | 0.06206 ± 0.00041 | 2.1938 ± 0.0000 |
| 10007 | ForestGeometry | Confidence-heuristic | 0.8642 ± 0.0010 | 1.0000 ± 0.0000 | 0.1358 ± 0.0010 | 0.05952 ± 0.00026 | 2.4700 ± 0.0079 |
| 10007 | ForestGeometry | Risk-constrained-v6 | 0.8654 ± 0.0011 | 1.0000 ± 0.0000 | 0.1346 ± 0.0011 | 0.05840 ± 0.00027 | 2.6927 ± 0.0070 |
| 10007 | ForestGeometry | Constrained Oracle | 0.8699 ± 0.0011 | 1.0000 ± 0.0000 | 0.1301 ± 0.0011 | 0.05812 ± 0.00029 | 2.6651 ± 0.0058 |
| 10007 | ForestGeometry | DCC-like | 0.8700 ± 0.0005 | 1.0000 ± 0.0000 | 0.1300 ± 0.0005 | 0.08411 ± 0.00017 | 4.8213 ± 0.0006 |
| 10007 | ForestGeometry | AoI-aware | 0.8563 ± 0.0019 | 0.9993 ± 0.0004 | 0.1437 ± 0.0019 | 0.06132 ± 0.00048 | 2.2981 ± 0.0000 |
| 10015 | Default | Link-delay-aware | 0.9759 ± 0.0017 | 1.0000 ± 0.0000 | 0.0241 ± 0.0017 | 0.02429 ± 0.00070 | 1.1085 ± 0.0000 |
| 10015 | Default | Confidence-heuristic | 0.9967 ± 0.0006 | 1.0000 ± 0.0000 | 0.0033 ± 0.0006 | 0.01599 ± 0.00027 | 1.3573 ± 0.0051 |
| 10015 | Default | Risk-constrained-v6 | 0.9969 ± 0.0006 | 1.0000 ± 0.0000 | 0.0031 ± 0.0006 | 0.01583 ± 0.00023 | 1.3427 ± 0.0039 |
| 10015 | Default | Constrained Oracle | 0.9983 ± 0.0004 | 1.0000 ± 0.0000 | 0.0017 ± 0.0004 | 0.01615 ± 0.00021 | 1.3670 ± 0.0042 |
| 10015 | Default | DCC-like | 0.9639 ± 0.0015 | 1.0000 ± 0.0000 | 0.0361 ± 0.0015 | 0.02916 ± 0.00065 | 1.7816 ± 0.0000 |
| 10015 | Default | AoI-aware | 0.9821 ± 0.0011 | 0.9985 ± 0.0030 | 0.0179 ± 0.0011 | 0.02329 ± 0.00051 | 1.2907 ± 0.0000 |
| 10015 | ForestGeometry | Link-delay-aware | 0.8422 ± 0.0027 | 0.9985 ± 0.0030 | 0.1578 ± 0.0027 | 0.08650 ± 0.00132 | 1.0904 ± 0.0000 |
| 10015 | ForestGeometry | Confidence-heuristic | 0.8803 ± 0.0026 | 1.0000 ± 0.0000 | 0.1197 ± 0.0026 | 0.07037 ± 0.00119 | 1.3350 ± 0.0082 |
| 10015 | ForestGeometry | Risk-constrained-v6 | 0.9082 ± 0.0019 | 1.0000 ± 0.0000 | 0.0918 ± 0.0019 | 0.05579 ± 0.00086 | 1.5082 ± 0.0067 |
| 10015 | ForestGeometry | Constrained Oracle | 0.9135 ± 0.0015 | 0.9985 ± 0.0030 | 0.0865 ± 0.0015 | 0.05390 ± 0.00070 | 1.5334 ± 0.0057 |
| 10015 | ForestGeometry | DCC-like | 0.9163 ± 0.0013 | 1.0000 ± 0.0000 | 0.0837 ± 0.0013 | 0.05252 ± 0.00062 | 1.7483 ± 0.0003 |
| 10015 | ForestGeometry | AoI-aware | 0.8596 ± 0.0024 | 0.9862 ± 0.0083 | 0.1404 ± 0.0024 | 0.07944 ± 0.00116 | 1.3830 ± 0.0000 |

## 3. 场景级实践显著性摘要

| Scene | Config | Baseline | Proposed | ΔTimely (pp) | ΔEmergency (pp) | ΔCost (%) | Holm p | Effect RBC | Class |
|---|---|---|---|---:|---:|---:|---|---:|---|
| 10014 | Default | DCC-like | Risk-constrained-v6 | 1.195 | 0.000 | -50.88 | p < 2.3e-308 | 0.998 | MeaningfulGain |
| 10014 | ForestGeometry | DCC-like | Risk-constrained-v6 | -0.043 | 1.333 | -40.95 | p = 1 | -0.110 | MeaningfulGain |
| 10006 | Default | DCC-like | Risk-constrained-v6 | 7.155 | -0.046 | -36.23 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10006 | ForestGeometry | DCC-like | Risk-constrained-v6 | 0.419 | 0.151 | -30.30 | p = 6.147e-11 | 0.918 | WeakNonnegative |
| 10011 | Default | DCC-like | Risk-constrained-v6 | -0.486 | 0.000 | -47.90 | p < 2.3e-308 | -1.000 | Boundary |
| 10011 | ForestGeometry | DCC-like | Risk-constrained-v6 | 19.441 | 9.300 | 8.85 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10019 | Default | DCC-like | Risk-constrained-v6 | -0.013 | 0.000 | -33.53 | p = 0.117 | -1.000 | Boundary |
| 10019 | ForestGeometry | DCC-like | Risk-constrained-v6 | 0.572 | 0.645 | -12.06 | p = 4.811e-06 | 0.647 | WeakNonnegative |
| 10017 | Default | DCC-like | Risk-constrained-v6 | 8.476 | -1.222 | -39.30 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10017 | ForestGeometry | DCC-like | Risk-constrained-v6 | 1.138 | 0.278 | -25.64 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10013 | Default | DCC-like | Risk-constrained-v6 | -0.745 | 0.000 | -33.92 | p < 2.3e-308 | -1.000 | Boundary |
| 10013 | ForestGeometry | DCC-like | Risk-constrained-v6 | 0.872 | 0.851 | 2.36 | p < 2.3e-308 | 0.910 | WeakNonnegative |
| 10007 | Default | DCC-like | Risk-constrained-v6 | 6.899 | 0.000 | -41.45 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10007 | ForestGeometry | DCC-like | Risk-constrained-v6 | -0.466 | 0.000 | -44.15 | p < 2.3e-308 | -0.963 | Boundary |
| 10015 | Default | DCC-like | Risk-constrained-v6 | 3.298 | 0.000 | -24.64 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10015 | ForestGeometry | DCC-like | Risk-constrained-v6 | -0.809 | 0.000 | -13.73 | p < 2.3e-308 | -0.996 | Boundary |
| 10014 | Default | AoI-aware | Risk-constrained-v6 | 1.478 | 13.667 | -9.04 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10014 | ForestGeometry | AoI-aware | Risk-constrained-v6 | 0.612 | 0.667 | -3.58 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10006 | Default | AoI-aware | Risk-constrained-v6 | 1.797 | 0.533 | 20.14 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10006 | ForestGeometry | AoI-aware | Risk-constrained-v6 | 0.116 | 0.125 | 9.29 | p = 0.02851 | 0.448 | WeakNonnegative |
| 10011 | Default | AoI-aware | Risk-constrained-v6 | 0.190 | 0.300 | 2.87 | p = 3.617e-08 | 0.940 | WeakNonnegative |
| 10011 | ForestGeometry | AoI-aware | Risk-constrained-v6 | -0.273 | 15.800 | -20.15 | p = 0.07137 | -0.375 | MeaningfulGain |
| 10019 | Default | AoI-aware | Risk-constrained-v6 | 0.193 | 0.212 | 80.44 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10019 | ForestGeometry | AoI-aware | Risk-constrained-v6 | -0.832 | -0.916 | 0.23 | p = 2.309e-14 | -0.934 | Boundary |
| 10017 | Default | AoI-aware | Risk-constrained-v6 | 3.042 | 3.889 | -13.80 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10017 | ForestGeometry | AoI-aware | Risk-constrained-v6 | -0.479 | -0.611 | -26.73 | p < 2.3e-308 | -0.956 | Boundary |
| 10013 | Default | AoI-aware | Risk-constrained-v6 | 0.552 | 0.650 | 80.39 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10013 | ForestGeometry | AoI-aware | Risk-constrained-v6 | -0.103 | 0.048 | 1.58 | p = 0.5027 | -0.157 | Boundary |
| 10007 | Default | AoI-aware | Risk-constrained-v6 | 1.787 | 0.071 | 23.11 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10007 | ForestGeometry | AoI-aware | Risk-constrained-v6 | 0.908 | 0.071 | 17.17 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10015 | Default | AoI-aware | Risk-constrained-v6 | 1.478 | 0.154 | 4.02 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10015 | ForestGeometry | AoI-aware | Risk-constrained-v6 | 4.865 | 1.385 | 9.05 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10014 | Default | Link-delay-aware | Risk-constrained-v6 | 5.724 | 1.667 | 22.77 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10014 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | 1.181 | 0.000 | 34.50 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10006 | Default | Link-delay-aware | Risk-constrained-v6 | 5.900 | 0.434 | 29.31 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10006 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | 0.619 | 0.000 | 28.01 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10011 | Default | Link-delay-aware | Risk-constrained-v6 | 0.233 | 0.000 | 9.86 | p = 1.776e-14 | 1.000 | WeakNonnegative |
| 10011 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | 12.889 | 3.400 | 36.84 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10019 | Default | Link-delay-aware | Risk-constrained-v6 | 0.000 | 0.000 | 21.81 | p = 1 | 0.000 | WeakNonnegative |
| 10019 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | -0.715 | -0.788 | 16.93 | p < 2.3e-308 | -0.957 | Boundary |
| 10017 | Default | Link-delay-aware | Risk-constrained-v6 | 11.085 | 4.944 | 40.17 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10017 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | 0.905 | 0.000 | 37.84 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10013 | Default | Link-delay-aware | Risk-constrained-v6 | 0.023 | 0.026 | 21.77 | p = 0.01421 | 1.000 | WeakNonnegative |
| 10013 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | -0.589 | -0.694 | 17.17 | p < 2.3e-308 | -0.961 | Boundary |
| 10007 | Default | Link-delay-aware | Risk-constrained-v6 | 3.957 | 0.000 | 25.33 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10007 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | 1.381 | 0.000 | 22.75 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10015 | Default | Link-delay-aware | Risk-constrained-v6 | 2.103 | 0.000 | 21.13 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10015 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | 6.602 | 0.154 | 38.31 | p < 2.3e-308 | 1.000 | CostlyGain |
| 10014 | Default | Confidence-heuristic | Risk-constrained-v6 | 0.343 | 0.000 | -4.40 | p = 1.202e-07 | 0.749 | WeakNonnegative |
| 10014 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | 1.032 | 0.333 | 9.40 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10006 | Default | Confidence-heuristic | Risk-constrained-v6 | 0.176 | 0.000 | 4.53 | p = 0.00484 | 0.560 | WeakNonnegative |
| 10006 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | 0.522 | -0.007 | 10.86 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10011 | Default | Confidence-heuristic | Risk-constrained-v6 | 0.123 | 0.000 | -3.63 | p = 2.476e-04 | 0.676 | WeakNonnegative |
| 10011 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | 4.100 | 0.100 | 7.31 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10019 | Default | Confidence-heuristic | Risk-constrained-v6 | 0.000 | 0.000 | 2.16 | p = 1 | 0.000 | WeakNonnegative |
| 10019 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | -0.672 | -0.740 | -0.53 | p = 4.441e-14 | -0.880 | Boundary |
| 10017 | Default | Confidence-heuristic | Risk-constrained-v6 | 0.173 | 0.000 | -3.77 | p = 0.05784 | 0.369 | WeakNonnegative |
| 10017 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | 0.619 | 0.000 | 12.12 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10013 | Default | Confidence-heuristic | Risk-constrained-v6 | 0.000 | 0.000 | 2.54 | p = 1 | 0.000 | WeakNonnegative |
| 10013 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | -0.459 | -0.536 | 6.25 | p = 3.115e-08 | -0.760 | Boundary |
| 10007 | Default | Confidence-heuristic | Risk-constrained-v6 | 0.063 | 0.000 | 2.90 | p = 0.2727 | 0.301 | WeakNonnegative |
| 10007 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | 0.120 | 0.000 | 9.02 | p = 9.603e-04 | 0.579 | WeakNonnegative |
| 10015 | Default | Confidence-heuristic | Risk-constrained-v6 | 0.017 | 0.000 | -1.08 | p = 1 | 0.208 | WeakNonnegative |
| 10015 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | 2.789 | 0.000 | 12.98 | p < 2.3e-308 | 1.000 | MeaningfulGain |
| 10014 | Default | Risk-constrained-v6 | Constrained Oracle | 0.426 | -1.667 | 5.10 | p < 2.3e-308 | 0.973 | Risk |
| 10014 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | 0.286 | -0.333 | 5.74 | p = 2.067e-10 | 0.853 | Boundary |
| 10006 | Default | Risk-constrained-v6 | Constrained Oracle | 0.526 | 0.112 | -4.10 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10006 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | 0.077 | -0.033 | -5.31 | p = 0.1744 | 0.369 | WeakNonnegative |
| 10011 | Default | Risk-constrained-v6 | Constrained Oracle | 0.356 | 0.000 | 2.92 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10011 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | -1.161 | -0.800 | 8.82 | p < 2.3e-308 | -0.997 | Risk |
| 10019 | Default | Risk-constrained-v6 | Constrained Oracle | 0.000 | 0.000 | -17.63 | p = 1 | 0.000 | WeakNonnegative |
| 10019 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | -0.536 | -0.590 | -9.72 | p = 1.309e-10 | -0.828 | Boundary |
| 10017 | Default | Risk-constrained-v6 | Constrained Oracle | 0.998 | -0.833 | 12.23 | p < 2.3e-308 | 0.998 | Boundary |
| 10017 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | 0.609 | -0.167 | 25.31 | p < 2.3e-308 | 0.994 | Boundary |
| 10013 | Default | Risk-constrained-v6 | Constrained Oracle | 0.393 | -0.026 | -16.58 | p < 2.3e-308 | 1.000 | WeakNonnegative |
| 10013 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | -0.399 | -0.756 | -0.32 | p = 1.282e-07 | -0.792 | Boundary |
| 10007 | Default | Risk-constrained-v6 | Constrained Oracle | 0.130 | 0.000 | -5.15 | p = 6.946e-07 | 0.784 | WeakNonnegative |
| 10007 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | 0.449 | 0.000 | -1.03 | p < 2.3e-308 | 0.988 | WeakNonnegative |
| 10015 | Default | Risk-constrained-v6 | Constrained Oracle | 0.140 | 0.000 | 1.81 | p = 8.038e-10 | 0.918 | WeakNonnegative |
| 10015 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | 0.532 | -0.154 | 1.67 | p < 2.3e-308 | 0.994 | Boundary |

## 4. PosDeg_Emerg 关键阶段统计

| Scene | Config | Baseline | Proposed | Metric | Delta | Holm p | Effect RBC | Practical note |
|---|---|---|---|---|---:|---|---:|---|
| 10014 | Default | DCC-like | Risk-constrained-v6 | TimelyRate | -0.004727 | p = 1.707e-06 | -0.933 | Below1pp |
| 10014 | Default | DCC-like | Risk-constrained-v6 | LossRate | 0.004727 | p = 1.707e-06 | 0.933 | Below1pp |
| 10014 | Default | DCC-like | Risk-constrained-v6 | AvgTxCost | -2.138427 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | Default | DCC-like | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10014 | ForestGeometry | DCC-like | Risk-constrained-v6 | TimelyRate | 0.006182 | p = 8.974e-08 | 1.000 | Below1pp |
| 10014 | ForestGeometry | DCC-like | Risk-constrained-v6 | LossRate | -0.006545 | p = 1.598e-07 | -0.957 | Below1pp |
| 10014 | ForestGeometry | DCC-like | Risk-constrained-v6 | AvgTxCost | -1.153745 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | ForestGeometry | DCC-like | Risk-constrained-v6 | EmgTimely | 0.013333 | p = 0.039 | 1.000 | Meaningful |
| 10006 | Default | DCC-like | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | Default | DCC-like | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | Default | DCC-like | Risk-constrained-v6 | AvgTxCost | -1.440000 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10006 | Default | DCC-like | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | ForestGeometry | DCC-like | Risk-constrained-v6 | TimelyRate | 0.000909 | p = 0.323 | 0.385 | Below1pp |
| 10006 | ForestGeometry | DCC-like | Risk-constrained-v6 | LossRate | -0.001455 | p = 0.117 | -0.571 | Below1pp |
| 10006 | ForestGeometry | DCC-like | Risk-constrained-v6 | AvgTxCost | -1.197491 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10006 | ForestGeometry | DCC-like | Risk-constrained-v6 | EmgTimely | 0.000909 | p = 0.323 | 0.385 | Below1pp |
| 10011 | Default | DCC-like | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | Default | DCC-like | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | Default | DCC-like | Risk-constrained-v6 | AvgTxCost | -1.010909 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | Default | DCC-like | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10011 | ForestGeometry | DCC-like | Risk-constrained-v6 | TimelyRate | -0.008545 | p = 8.313e-11 | -1.000 | Below1pp |
| 10011 | ForestGeometry | DCC-like | Risk-constrained-v6 | LossRate | 0.008545 | p = 8.313e-11 | 1.000 | Below1pp |
| 10011 | ForestGeometry | DCC-like | Risk-constrained-v6 | AvgTxCost | -0.786418 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | ForestGeometry | DCC-like | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10019 | Default | DCC-like | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | Default | DCC-like | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | Default | DCC-like | Risk-constrained-v6 | AvgTxCost | -1.324091 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10019 | Default | DCC-like | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | ForestGeometry | DCC-like | Risk-constrained-v6 | TimelyRate | 0.004727 | p = 0.4961 | 0.198 | Below1pp |
| 10019 | ForestGeometry | DCC-like | Risk-constrained-v6 | LossRate | -0.247636 | p < 2.3e-308 | -1.000 | Meaningful |
| 10019 | ForestGeometry | DCC-like | Risk-constrained-v6 | AvgTxCost | 1.428480 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | ForestGeometry | DCC-like | Risk-constrained-v6 | EmgTimely | 0.004727 | p = 0.4961 | 0.198 | Below1pp |
| 10017 | Default | DCC-like | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10017 | Default | DCC-like | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10017 | Default | DCC-like | Risk-constrained-v6 | AvgTxCost | -3.411291 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | Default | DCC-like | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10017 | ForestGeometry | DCC-like | Risk-constrained-v6 | TimelyRate | -0.000182 | p = 0.9519 | -1.000 | Below1pp |
| 10017 | ForestGeometry | DCC-like | Risk-constrained-v6 | LossRate | 0.000182 | p = 0.9519 | 1.000 | Below1pp |
| 10017 | ForestGeometry | DCC-like | Risk-constrained-v6 | AvgTxCost | -3.308382 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | ForestGeometry | DCC-like | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10013 | Default | DCC-like | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | Default | DCC-like | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | Default | DCC-like | Risk-constrained-v6 | AvgTxCost | -1.440000 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10013 | Default | DCC-like | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | ForestGeometry | DCC-like | Risk-constrained-v6 | TimelyRate | 0.005818 | p = 0.2598 | 0.246 | Below1pp |
| 10013 | ForestGeometry | DCC-like | Risk-constrained-v6 | LossRate | -0.135455 | p < 2.3e-308 | -1.000 | Meaningful |
| 10013 | ForestGeometry | DCC-like | Risk-constrained-v6 | AvgTxCost | 0.305400 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | ForestGeometry | DCC-like | Risk-constrained-v6 | EmgTimely | 0.005818 | p = 0.2598 | 0.246 | Below1pp |
| 10007 | Default | DCC-like | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | Default | DCC-like | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | Default | DCC-like | Risk-constrained-v6 | AvgTxCost | -1.574982 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | Default | DCC-like | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | DCC-like | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | DCC-like | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | DCC-like | Risk-constrained-v6 | AvgTxCost | -1.560164 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | ForestGeometry | DCC-like | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | DCC-like | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | DCC-like | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | DCC-like | Risk-constrained-v6 | AvgTxCost | -0.261418 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10015 | Default | DCC-like | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10015 | ForestGeometry | DCC-like | Risk-constrained-v6 | TimelyRate | -0.010364 | p = 2.349e-12 | -0.946 | Meaningful |
| 10015 | ForestGeometry | DCC-like | Risk-constrained-v6 | LossRate | 0.010364 | p = 2.349e-12 | 0.946 | Meaningful |
| 10015 | ForestGeometry | DCC-like | Risk-constrained-v6 | AvgTxCost | -0.232355 | p < 2.3e-308 | -0.998 | SeeDelta |
| 10015 | ForestGeometry | DCC-like | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10014 | Default | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.026000 | p < 2.3e-308 | 1.000 | Meaningful |
| 10014 | Default | AoI-aware | Risk-constrained-v6 | LossRate | -0.026000 | p < 2.3e-308 | -1.000 | Meaningful |
| 10014 | Default | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.650745 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10014 | Default | AoI-aware | Risk-constrained-v6 | EmgTimely | 0.136667 | p = 2.153e-12 | 1.000 | Meaningful |
| 10014 | ForestGeometry | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.006000 | p = 7.310e-07 | 1.000 | Below1pp |
| 10014 | ForestGeometry | AoI-aware | Risk-constrained-v6 | LossRate | -0.006182 | p = 2.656e-06 | -0.953 | Below1pp |
| 10014 | ForestGeometry | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.997891 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10014 | ForestGeometry | AoI-aware | Risk-constrained-v6 | EmgTimely | 0.006667 | p = 0.153 | 1.000 | Below1pp |
| 10006 | Default | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.005455 | p = 7.305e-10 | 1.000 | Below1pp |
| 10006 | Default | AoI-aware | Risk-constrained-v6 | LossRate | -0.005455 | p = 7.305e-10 | -1.000 | Below1pp |
| 10006 | Default | AoI-aware | Risk-constrained-v6 | AvgTxCost | 1.509273 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | Default | AoI-aware | Risk-constrained-v6 | EmgTimely | 0.005455 | p = 7.305e-10 | 1.000 | Below1pp |
| 10006 | ForestGeometry | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.000909 | p = 0.446 | 0.333 | Below1pp |
| 10006 | ForestGeometry | AoI-aware | Risk-constrained-v6 | LossRate | 0.001273 | p = 0.1369 | 0.636 | Below1pp |
| 10006 | ForestGeometry | AoI-aware | Risk-constrained-v6 | AvgTxCost | 1.004509 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | ForestGeometry | AoI-aware | Risk-constrained-v6 | EmgTimely | 0.000909 | p = 0.446 | 0.333 | Below1pp |
| 10011 | Default | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.000727 | p = 0.117 | 1.000 | Below1pp |
| 10011 | Default | AoI-aware | Risk-constrained-v6 | LossRate | -0.000727 | p = 0.117 | -1.000 | Below1pp |
| 10011 | Default | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.522909 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10011 | Default | AoI-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10011 | ForestGeometry | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.051273 | p < 2.3e-308 | 1.000 | Meaningful |
| 10011 | ForestGeometry | AoI-aware | Risk-constrained-v6 | LossRate | -0.051273 | p < 2.3e-308 | -1.000 | Meaningful |
| 10011 | ForestGeometry | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.747400 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10011 | ForestGeometry | AoI-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10019 | Default | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.000727 | p = 0.117 | 1.000 | Below1pp |
| 10019 | Default | AoI-aware | Risk-constrained-v6 | LossRate | -0.000727 | p = 0.117 | -1.000 | Below1pp |
| 10019 | Default | AoI-aware | Risk-constrained-v6 | AvgTxCost | 1.509273 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | Default | AoI-aware | Risk-constrained-v6 | EmgTimely | 0.000727 | p = 0.117 | 1.000 | Below1pp |
| 10019 | ForestGeometry | AoI-aware | Risk-constrained-v6 | TimelyRate | -0.039091 | p < 2.3e-308 | -0.997 | Meaningful |
| 10019 | ForestGeometry | AoI-aware | Risk-constrained-v6 | LossRate | -0.061091 | p < 2.3e-308 | -1.000 | Meaningful |
| 10019 | ForestGeometry | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.271571 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | ForestGeometry | AoI-aware | Risk-constrained-v6 | EmgTimely | -0.039091 | p < 2.3e-308 | -0.997 | Meaningful |
| 10017 | Default | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.000727 | p = 0.117 | 1.000 | Below1pp |
| 10017 | Default | AoI-aware | Risk-constrained-v6 | LossRate | -0.000727 | p = 0.117 | -1.000 | Below1pp |
| 10017 | Default | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.521073 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10017 | Default | AoI-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10017 | ForestGeometry | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.000545 | p = 0.2309 | 1.000 | Below1pp |
| 10017 | ForestGeometry | AoI-aware | Risk-constrained-v6 | LossRate | -0.000545 | p = 0.2309 | -1.000 | Below1pp |
| 10017 | ForestGeometry | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.623982 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10017 | ForestGeometry | AoI-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10013 | Default | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.000727 | p = 0.117 | 1.000 | Below1pp |
| 10013 | Default | AoI-aware | Risk-constrained-v6 | LossRate | -0.000727 | p = 0.117 | -1.000 | Below1pp |
| 10013 | Default | AoI-aware | Risk-constrained-v6 | AvgTxCost | 1.509273 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | Default | AoI-aware | Risk-constrained-v6 | EmgTimely | 0.000727 | p = 0.117 | 1.000 | Below1pp |
| 10013 | ForestGeometry | AoI-aware | Risk-constrained-v6 | TimelyRate | -0.027455 | p < 2.3e-308 | -0.963 | Meaningful |
| 10013 | ForestGeometry | AoI-aware | Risk-constrained-v6 | LossRate | 0.002182 | p = 0.557 | 0.111 | Below1pp |
| 10013 | ForestGeometry | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.087218 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | ForestGeometry | AoI-aware | Risk-constrained-v6 | EmgTimely | -0.027455 | p < 2.3e-308 | -0.963 | Meaningful |
| 10007 | Default | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.000545 | p = 0.2309 | 1.000 | Below1pp |
| 10007 | Default | AoI-aware | Risk-constrained-v6 | LossRate | -0.000545 | p = 0.2309 | -1.000 | Below1pp |
| 10007 | Default | AoI-aware | Risk-constrained-v6 | AvgTxCost | 1.430473 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | Default | AoI-aware | Risk-constrained-v6 | EmgTimely | 0.000577 | p = 0.2309 | 1.000 | Below1pp |
| 10007 | ForestGeometry | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.000545 | p = 0.2309 | 1.000 | Below1pp |
| 10007 | ForestGeometry | AoI-aware | Risk-constrained-v6 | LossRate | -0.000545 | p = 0.2309 | -1.000 | Below1pp |
| 10007 | ForestGeometry | AoI-aware | Risk-constrained-v6 | AvgTxCost | 1.445291 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | ForestGeometry | AoI-aware | Risk-constrained-v6 | EmgTimely | 0.000577 | p = 0.2309 | 1.000 | Below1pp |
| 10015 | Default | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.000545 | p = 0.2309 | 1.000 | Below1pp |
| 10015 | Default | AoI-aware | Risk-constrained-v6 | LossRate | -0.000545 | p = 0.2309 | -1.000 | Below1pp |
| 10015 | Default | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.344764 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | Default | AoI-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10015 | ForestGeometry | AoI-aware | Risk-constrained-v6 | TimelyRate | 0.034364 | p < 2.3e-308 | 1.000 | Meaningful |
| 10015 | ForestGeometry | AoI-aware | Risk-constrained-v6 | LossRate | -0.034364 | p < 2.3e-308 | -1.000 | Meaningful |
| 10015 | ForestGeometry | AoI-aware | Risk-constrained-v6 | AvgTxCost | 0.373827 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | ForestGeometry | AoI-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10014 | Default | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.026182 | p < 2.3e-308 | 1.000 | Meaningful |
| 10014 | Default | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.026182 | p < 2.3e-308 | -1.000 | Meaningful |
| 10014 | Default | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.843655 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10014 | Default | Link-delay-aware | Risk-constrained-v6 | EmgTimely | 0.016667 | p = 0.01963 | 1.000 | Meaningful |
| 10014 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.005455 | p = 2.301e-08 | 1.000 | Below1pp |
| 10014 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.005455 | p = 2.301e-08 | -1.000 | Below1pp |
| 10014 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 1.216073 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10014 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | Default | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000182 | p = 0.9519 | 1.000 | Below1pp |
| 10006 | Default | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.000182 | p = 0.9519 | -1.000 | Below1pp |
| 10006 | Default | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.600000 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | Default | Link-delay-aware | Risk-constrained-v6 | EmgTimely | 0.000182 | p = 0.9519 | 1.000 | Below1pp |
| 10006 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.538145 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | Default | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000727 | p = 0.156 | 1.000 | Below1pp |
| 10011 | Default | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.000727 | p = 0.156 | -1.000 | Below1pp |
| 10011 | Default | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.710545 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10011 | Default | Link-delay-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10011 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.055455 | p < 2.3e-308 | 1.000 | Meaningful |
| 10011 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.055455 | p < 2.3e-308 | -1.000 | Meaningful |
| 10011 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.935036 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10011 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10019 | Default | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | Default | Link-delay-aware | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | Default | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.600000 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | Default | Link-delay-aware | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | TimelyRate | -0.042182 | p < 2.3e-308 | -1.000 | Meaningful |
| 10019 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.118000 | p < 2.3e-308 | -1.000 | Meaningful |
| 10019 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.992662 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | EmgTimely | -0.042182 | p < 2.3e-308 | -1.000 | Meaningful |
| 10017 | Default | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000727 | p = 0.156 | 1.000 | Below1pp |
| 10017 | Default | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.000727 | p = 0.156 | -1.000 | Below1pp |
| 10017 | Default | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.708709 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10017 | Default | Link-delay-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10017 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000545 | p = 0.3079 | 1.000 | Below1pp |
| 10017 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.000545 | p = 0.3079 | -1.000 | Below1pp |
| 10017 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.811618 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10017 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10013 | Default | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | Default | Link-delay-aware | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | Default | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.600000 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | Default | Link-delay-aware | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | TimelyRate | -0.021818 | p < 2.3e-308 | -0.959 | Meaningful |
| 10013 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.058000 | p < 2.3e-308 | -1.000 | Meaningful |
| 10013 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.718036 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | EmgTimely | -0.021818 | p < 2.3e-308 | -0.959 | Meaningful |
| 10007 | Default | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | Default | Link-delay-aware | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | Default | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.578473 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | Default | Link-delay-aware | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.593291 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.000727 | p = 0.156 | 1.000 | Below1pp |
| 10015 | Default | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.000727 | p = 0.156 | -1.000 | Below1pp |
| 10015 | Default | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.438582 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | Default | Link-delay-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10015 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | TimelyRate | 0.038182 | p < 2.3e-308 | 1.000 | Meaningful |
| 10015 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | LossRate | -0.038182 | p < 2.3e-308 | -1.000 | Meaningful |
| 10015 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | AvgTxCost | 0.467645 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10015 | ForestGeometry | Link-delay-aware | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10014 | Default | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | -0.003636 | p = 2.866e-05 | -1.000 | Below1pp |
| 10014 | Default | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.003636 | p = 2.866e-05 | 1.000 | Below1pp |
| 10014 | Default | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | -0.401344 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | Default | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10014 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000182 | p = 0.6346 | 0.333 | Below1pp |
| 10014 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000545 | p = 0.5284 | 0.600 | Below1pp |
| 10014 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | -0.300251 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10014 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | 0.003333 | p = 0.6346 | 1.000 | Below1pp |
| 10006 | Default | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | Default | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | Default | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | 0.494182 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | Default | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000182 | p = 1 | 0.111 | Below1pp |
| 10006 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.001455 | p = 0.02196 | 1.000 | Below1pp |
| 10006 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | 0.227269 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10006 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | 0.000182 | p = 1 | 0.111 | Below1pp |
| 10011 | Default | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | Default | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | Default | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | -0.307673 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | Default | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10011 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | -0.002909 | p = 1.208e-04 | -1.000 | Below1pp |
| 10011 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.002909 | p = 1.208e-04 | 1.000 | Below1pp |
| 10011 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | -0.232655 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10011 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10019 | Default | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | Default | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | Default | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | 0.146618 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10019 | Default | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | -0.037636 | p < 2.3e-308 | -0.973 | Meaningful |
| 10019 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | LossRate | -0.044182 | p < 2.3e-308 | -0.964 | Meaningful |
| 10019 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | 0.164324 | p < 1e-15 | 0.919 | SeeDelta |
| 10019 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | -0.037636 | p < 2.3e-308 | -0.973 | Meaningful |
| 10017 | Default | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10017 | Default | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10017 | Default | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | -0.308236 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | Default | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10017 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | -0.000182 | p = 1 | -1.000 | Below1pp |
| 10017 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000182 | p = 1 | 1.000 | Below1pp |
| 10017 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | -0.285073 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10017 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10013 | Default | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | Default | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | Default | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | 0.268145 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10013 | Default | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | -0.019455 | p = 1.442e-11 | -0.872 | Meaningful |
| 10013 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | LossRate | -0.013273 | p = 0.002051 | -0.507 | Meaningful |
| 10013 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | 0.068095 | p = 0.002051 | 0.418 | SeeDelta |
| 10013 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | -0.019455 | p = 1.442e-11 | -0.872 | Meaningful |
| 10007 | Default | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | Default | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | Default | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | 0.497327 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | Default | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | 0.398073 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10007 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | Confidence-heuristic | Risk-constrained-v6 | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | -0.048455 | p < 2.3e-308 | -0.997 | SeeDelta |
| 10015 | Default | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10015 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | TimelyRate | 0.000727 | p = 0.117 | 1.000 | Below1pp |
| 10015 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | LossRate | -0.000727 | p = 0.117 | -1.000 | Below1pp |
| 10015 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | AvgTxCost | -0.060673 | p < 2.3e-308 | -0.998 | SeeDelta |
| 10015 | ForestGeometry | Confidence-heuristic | Risk-constrained-v6 | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10014 | Default | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.002545 | p = 0.03451 | 0.605 | Below1pp |
| 10014 | Default | Risk-constrained-v6 | Constrained Oracle | LossRate | -0.002545 | p = 0.03451 | -0.605 | Below1pp |
| 10014 | Default | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | 0.147473 | p < 2.3e-308 | 0.989 | SeeDelta |
| 10014 | Default | Risk-constrained-v6 | Constrained Oracle | EmgTimely | -0.016667 | p = 0.03451 | -1.000 | Meaningful |
| 10014 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | TimelyRate | -0.000000 | p = 1 | 0.000 | Below1pp |
| 10014 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000182 | p = 1 | 0.200 | Below1pp |
| 10014 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | 0.132189 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10014 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | EmgTimely | -0.003333 | p = 0.9519 | -1.000 | Below1pp |
| 10006 | Default | Risk-constrained-v6 | Constrained Oracle | TimelyRate | -0.000182 | p = 0.9519 | -1.000 | Below1pp |
| 10006 | Default | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000182 | p = 0.9519 | 1.000 | Below1pp |
| 10006 | Default | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | -0.597382 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10006 | Default | Risk-constrained-v6 | Constrained Oracle | EmgTimely | -0.000182 | p = 0.9519 | -1.000 | Below1pp |
| 10006 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | TimelyRate | -0.000545 | p = 1 | -0.273 | Below1pp |
| 10006 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10006 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | -0.398978 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10006 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | EmgTimely | -0.000545 | p = 1 | -0.273 | Below1pp |
| 10011 | Default | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | Default | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10011 | Default | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | 0.166109 | p < 2.3e-308 | 0.998 | SeeDelta |
| 10011 | Default | Risk-constrained-v6 | Constrained Oracle | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10011 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.003818 | p = 4.628e-04 | 0.733 | Below1pp |
| 10011 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | LossRate | -0.003818 | p = 4.628e-04 | -0.733 | Below1pp |
| 10011 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | 0.087982 | p < 2.3e-308 | 0.998 | SeeDelta |
| 10011 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10019 | Default | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | Default | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | Default | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | -0.556036 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10019 | Default | Risk-constrained-v6 | Constrained Oracle | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10019 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | TimelyRate | -0.018364 | p = 7.457e-07 | -0.738 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | LossRate | -0.023818 | p = 3.712e-11 | -0.863 | Meaningful |
| 10019 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | 0.093131 | p = 1.510e-08 | 0.746 | SeeDelta |
| 10019 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | EmgTimely | -0.018364 | p = 7.457e-07 | -0.738 | Meaningful |
| 10017 | Default | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10017 | Default | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10017 | Default | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | 0.166545 | p < 2.3e-308 | 0.998 | SeeDelta |
| 10017 | Default | Risk-constrained-v6 | Constrained Oracle | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10017 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.000182 | p = 0.9519 | 1.000 | Below1pp |
| 10017 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | LossRate | -0.000182 | p = 0.9519 | -1.000 | Below1pp |
| 10017 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | 0.132000 | p < 2.3e-308 | 1.000 | SeeDelta |
| 10017 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10013 | Default | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | Default | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | Default | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | -0.565418 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10013 | Default | Risk-constrained-v6 | Constrained Oracle | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10013 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | TimelyRate | -0.014182 | p = 3.575e-08 | -0.770 | Meaningful |
| 10013 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | LossRate | -0.016364 | p = 3.575e-08 | -0.746 | Meaningful |
| 10013 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | 0.000393 | p = 0.9831 | 0.079 | SeeDelta |
| 10013 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | EmgTimely | -0.014182 | p = 3.575e-08 | -0.770 | Meaningful |
| 10007 | Default | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | Default | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | Default | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | -0.546909 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | Default | Risk-constrained-v6 | Constrained Oracle | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10007 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | -0.495600 | p < 2.3e-308 | -1.000 | SeeDelta |
| 10007 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | EmgTimely | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | Risk-constrained-v6 | Constrained Oracle | LossRate | 0.000000 | p = 1 | 0.000 | Below1pp |
| 10015 | Default | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | -0.013836 | p < 2.3e-308 | -0.991 | SeeDelta |
| 10015 | Default | Risk-constrained-v6 | Constrained Oracle | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |
| 10015 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | TimelyRate | 0.005636 | p = 1.569e-07 | 0.942 | Below1pp |
| 10015 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | LossRate | -0.005636 | p = 1.569e-07 | -0.942 | Below1pp |
| 10015 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | AvgTxCost | 0.047000 | p < 2.3e-308 | 0.947 | SeeDelta |
| 10015 | ForestGeometry | Risk-constrained-v6 | Constrained Oracle | EmgTimely | NaN | p = 1 | 0.000 | NotApplicable |

## 5. 审稿口径

1. 统计表必须与 Step54 文献基线表共同使用，避免只报告均值。
2. `Below1pp` 或 `Boundary` 结果不能包装成强性能提升，应作为弱收益或适用边界。
3. Holm 校正和 effect size 已给出，可用于回应多重比较和实际显著性问题。
