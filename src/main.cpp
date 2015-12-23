#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <set>
#include <string>
#include <map>
#include <vector>
#include <iostream>
#include <fstream>

using namespace std;


const string rsize[] = {"1024", "4096", "16384", "65536", "262144", "1048576"};
const string wsize[] = {"1024", "4096", "16384", "65536", "262144", "1048576"};
const string actimeo[] ={"1","5","30"};
const string proto[] = {"tcp","udp"};
const string nfsvers[] = {"v3","v4"};
const string lock[] = {"lock","nolock"};
const string cto[] = {"cto", "nocto"};
const string acl[] = {"acl", "noacl"};
const string rdirplus[] = {"rdirplus", "nordirplus"};
const string security[] = {"sys", "none"};

const string accessPatterns[] = {"write", "rewrite", "read", "reread", "random read", "random write", "bkwd read",
                                "record rewrite", "stride read", "fwrite", "frewrite", "fread", "freread"};
const string nameParams[] = {"rsize", "wsize", "actimeo", "proto", "nfsvers", "lock", "cto", "acl",
                            "rdirplus", "security"};

struct parameters
{
    string p[10];
    parameters(string par[10])
    {
        for(int i=0;i<10;i++)
        {
            this->p[i] = par[i];
        }
    }
    parameters(){};
};

template<typename T1, typename T2>
pair<T1, T2> mp(T1 a, T2 b)
{
    return make_pair(a, b);
}

int main(int argc, char **argv)
{
    char filename[NAME_MAX];
    string file,buf;
    string arr[10] = {"1024","1024","1","tcp","v3","lock","cto","acl","rdirplus","sys"};
    parameters params(arr);
    long perf=0;
    //<32Mb
    std::map<int, pair<parameters, long> > lowRes;
    //>=32Mb
    std::map<int, pair<parameters, long> > highRes;
    for (int i = 1; i <= 13; i++)
    {
        highRes[i] = mp(params, perf);
        lowRes[i] = mp(params, perf);
    }


    if (argc < 2)
    {
        strcpy(filename, "");
    }
    else
    {
        strcpy(filename, argv[1]);
    }

    printf("%s\n", filename);

    for (auto rs : rsize)
    {
        for (auto ws : wsize)
        {
            for (auto act : actimeo)
            {
                for (auto pro : proto)
                {
                    for (auto nfs : nfsvers)
                    {
                        for (auto lk : lock)
                        {
                            for (auto ct : cto)
                            {
                                for (auto ac : acl)
                                {
                                    for (auto rdir : rdirplus)
                                    {
                                        for (auto sec : security)
                                        {
                                            string s(filename);
                                            file = s + "log/rs" + rs + "_ws" + ws + "_actimeo" +act + "_proto" + pro + "_" + nfs + "_" + lk + "_" + ct + "_" + ac + "_" + rdir + "_" + sec + ".log";
                                            ifstream fin(file);
                                            if(fin.is_open())
                                            {
                                                getline(fin,buf);
                                                //searching for files without err
                                                if(buf.find("err",0) == string::npos)
                                                {
                                                    while(!fin.eof())
                                                    {
                                                        getline(fin,buf);
                                                        if(buf.find("freread",0) != string::npos)
                                                        {
                                                            getline(fin,buf);

                                                            // for files <32Mb
                                                            for(int k=0;k<20;k++)
                                                            {
                                                                //two times without using
                                                                fin >> perf;
                                                                fin >> perf;
                                                                for(int i = 1; i <= 13; i++)
                                                                {
                                                                    fin >> perf;
                                                                    if(perf > lowRes[i].second)
                                                                    {
                                                                        params.p[0] = rs;
                                                                        params.p[1] = ws;
                                                                        params.p[2] = act;
                                                                        params.p[3] = pro;
                                                                        params.p[4] = nfs;
                                                                        params.p[5] = lk;
                                                                        params.p[6] = ct;
                                                                        params.p[7] = ac;
                                                                        params.p[8] = rdir;
                                                                        params.p[9] = sec;
                                                                        lowRes[i] = mp(params, perf);
                                                                    }
                                                                }
                                                            }

                                                            // for files >=32Mb
                                                            for(int k=0;k<18;k++)
                                                            {
                                                                //two times without using
                                                                fin >> perf;
                                                                fin >> perf;
                                                                for(int i = 1; i <= 13; i++)
                                                                {
                                                                    fin >> perf;
                                                                    if(perf > highRes[i].second)
                                                                    {
                                                                        params.p[0] = rs;
                                                                        params.p[1] = ws;
                                                                        params.p[2] = act;
                                                                        params.p[3] = pro;
                                                                        params.p[4] = nfs;
                                                                        params.p[5] = lk;
                                                                        params.p[6] = ct;
                                                                        params.p[7] = ac;
                                                                        params.p[8] = rdir;
                                                                        params.p[9] = sec;
                                                                        highRes[i] = mp(params, perf);
                                                                    }
                                                                }
                                                            }
                                                            break;
                                                        }
                                                    }
                                                }
                                                fin.close();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    printf("for files <32Mb\n");
    for(int i=1;i<=13;i++)
    {
        printf("\t%s: perfomance=%ld ( for parameters: ",accessPatterns[i-1].c_str(), lowRes[i].second);
        for(int j=0;j<10;j++)
        {
            printf("%s=%s ", nameParams[j].c_str(), lowRes[i].first.p[j].c_str());
        }
        printf(")\n");
    }

    printf("\nfor files >=32Mb\n");
    for(int i=1;i<=13;i++)
    {
        printf("\t%s: perfomance=%ld ( for parameters: ",accessPatterns[i-1].c_str(), highRes[i].second);
        for(int j=0;j<10;j++)
        {
            printf("%s=%s ", nameParams[j].c_str(), highRes[i].first.p[j].c_str());
        }
        printf(")\n");
    }


    return 0;
}
