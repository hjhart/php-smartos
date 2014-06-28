php_version = "php-#{node['php-smartos']['version']}"
tar_file = "#{php_version}.tar.gz"
downloadable_url = 'http://us1.php.net/distributions/#{tar_file}'

tmp_directory = Chef::Config[:file_cache_path]
php_directory = File.join(Chef::Config[:file_cache_path], php_version)

execute "curl -O #{downloadable_url}" do
  cwd tmp_directory
end

execute "untar the php archive" do
  command "tar xzf #{tar_file}"
  cwd tmp_directory
end

extra_opts = node['php-smartos']['extra_configure_options']
options = "--with-config-file-path=/opt/local/etc --with-config-file-scan-dir=/opt/local/etc/php.d --sysconfdir=/opt/local/etc --localstatedir=/var  --with-openssl=/opt/local --with-readline=/opt/local --enable-dtrace --prefix=/opt/local --build=x86_64-sun-solaris2.11 --host=x86_64-sun-solaris2.11 --mandir=/opt/local/man --without-sqlite3 --with-mysql --without-iconv --without-pear --disable-posix --disable-dom --disable-opcache --disable-pdo --disable-json --enable-cgi --enable-xml --with-libxml-dir=/opt/local #{extra_opts}"
configure_command = "./configure #{options}"

execute "configure PHP with appropriate options"
  command configure_command
  user root
  cwd php_directory
end

execute "make php"
  command "make"
  cwd php_directory
end

execute "make install php"
  command "make"
  cwd php_directory
end