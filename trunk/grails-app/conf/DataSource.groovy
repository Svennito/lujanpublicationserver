dataSource {
   pooled = true
   properties {
        maxActive = 5
        maxIdle = 5
        minIdle = 3
        initialSize = 5
        minEvictableIdleTimeMillis = 6000
        timeBetweenEvictionRunsMillis = 6000
        maxWait = 1000
        testOnBorrow = true
        testWhileIdle = true
        testOnReturn = false
        validationQuery = "select 1;"
    }
    driverClassName = "com.mysql.jdbc.Driver"
    username = "bibtex"
    password = "bibtex"
    dialect = "org.hibernate.dialect.MySQL5InnoDBDialect"	// this seems to be important to run.
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
}
// environment specific settings
environments {
    development {
        dataSource {
            // dbCreate = "create-drop" // one of 'create', 'create-drop', 'update', 'validate', ''
            dbCreate = "update"
            url = "jdbc:mysql://localhost/bibtex?autoReconnect=true"
        }          
    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:mysql://localhost/bibtex?autoReconnect=true"
        }
    }
    production {
        dataSource {
            dbCreate = "update"
            url = "jdbc:mysql://localhost/bibtex?autoReconnect=true"
            pooled = true
            properties {
               maxActive = -1
               minEvictableIdleTimeMillis=1800000
               timeBetweenEvictionRunsMillis=1800000
               numTestsPerEvictionRun=3
               testOnBorrow=true
               testWhileIdle=true
               testOnReturn=true
               validationQuery="SELECT 1"
            }
        }
    }
}
