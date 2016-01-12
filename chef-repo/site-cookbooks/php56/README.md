# php56 Cookbook

## Description
TODO: Enter the cookbook description here.

e.g.
This cookbook makes your favorite breakfast sandwich.

## Requirements

TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - php55 needs toaster to brown your bagel.

## Attributes

TODO: List your cookbook attributes here.

e.g.
#### php56::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['php56']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Note

* ``php-xml`` を入れないと ``composer`` で ``phpunit`` をインストールするときにコケる
* ``php-mcrypt`` をインストールする前に ``libmcrypt`` のインストールしないとコケる
* ``libmcrypt`` は ``remi`` には無い（？）ので ``epel`` からインストールする
