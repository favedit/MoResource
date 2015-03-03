资源存放规则

目录命名： 类型 + "-" + 英文缩写 "." + 二级缩写 + "." + 四位编号 + "-" + 中文解释
   类型：
      fd -> 文件夹，
      rs -> 资源
   英文缩写：
      grd     - ground     -> 地板
         .wal - wall       -> 墙壁
      bld     - building   -> 建筑
      plt     - plant      -> 植物
      anm     - animal     -> 动物
      dec     - decoration -> 装饰
         .sta - statue     -> 雕像
      trf     - traffic    -> 交通工具
      chr     - character  -> 角色
         .npc - npc        -> 角色
      ply     - player     -> 玩家角色

纹理: \texture
============================================================
类型列表
   m  - ambient             - 环境纹理
   d  - diffuse             - 漫反射纹理
   a  - alpha               - 透明纹理
   n  - normal              - 法线纹理
   h  - height              - 高度纹理
   s  - specular            - 高光纹理
   sl - specular.level      - 高光级别纹理
   tc - transmittance.color - 透射颜色纹理
   tl - transmittance.level - 透射级别纹理
   l  - light               - 光透纹理
   r  - reflect             - 反射纹理
   f  - refract             - 折射纹理
   e  - emissive            - 发光纹理
   c  - environment         - 环境纹理 (CubeMap)
注意点
   1. 纹理存储格式都是 .jpg 文件
   2. alpha/specular.level/light/reflect/refract/emissive 必须为黑白图，可以有灰度，但是不允许存在其他颜色。
   3. 纹理高度和宽度必须是2的次方，不能大于2048x2048。（比如：2/4/8/16/32/64/128/256/512/1024/2048）
   4. 纹理高宽可以不相等
   5. diffuse/alpha 纹理大小必须一致
   6. normal/specular.level 纹理大小必须一致
   7. specular/height 纹理大小必须一致
   8. light/reflect/refract/emissive 纹理大小必须一致
   9. environment大小必须是宽度是高度的6倍，顺序是 (X+, X-, Y+, Y-, Z+, Z-)


模型: \model
============================================================
命名：
   材质必须以 mt_ 开头，命名为 mt_ + 材质3位编号                     (例：mt_001)
   网格必须以 ms_ 开头，命名为 ms_ + 材质3位编号 + "_" + 网格3位编号 (例：ms_001_001)
注意：
   1. 材质中环境色/漫反射色/高光色/高光级别 将在最终材质中生效
   2. 网格必须存在对应的材质，不能单独存在，材质可以没有任何纹理贴图

地图: \map
============================================================

场景: \scene
============================================================
