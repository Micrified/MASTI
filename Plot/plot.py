# import matplotlib.pyplot as plt
import subprocess
import os
import csv
# import numpy as np
import time 

def process_txt(path, output_path, flag=True):
	with open(output_path, 'w') as csvfile:
		writer = csv.writer(csvfile, delimiter=',')
		with open(path) as file:
			minimum = None
			maximum = None
			mean = 0
			no = 0
			for line in file:
				if line.startswith("Resolver:"):
					if no != 0:
						mean = mean/no
						writer.writerow([resolver,round(minimum,2),round(mean,2),round(maximum,2),round(no/1000.0,2)])
						minimum = None
						maximum = None
						mean = 0
						no = 0
					resolver = line.replace("Resolver: ","")
					resolver = resolver.replace("\n","")
				else:
					if flag == True:
						if maximum == None or float(line) > maximum:
							maximum = float(line)
						if minimum == None or float(line) < minimum :
							minimum = float(line)					
						
						mean += float(line)
						no += 1
					else:
						#print(line)
						if maximum == None or int(line) > maximum:
							maximum = int(line)
						if minimum == None or int(line) < minimum :
							minimum = int(line)					
						
						mean += int(line)
						no += 1
					
def combain_all_csv(tlds,no):
	results = {
		'DNS' : '../NormalDNS/Results/',
		'DNSSec' : '../DNSSEC/Results/',
		'DoT' : '../DoT/Results/',
		'DoH' : '../DoH/Results/'
	}
<<<<<<< HEAD
	with open('allResults.csv', 'w') as csvfile:
=======
	with open('allResultsHungary.csv', 'w') as csvfile:
>>>>>>> 748abda2665e624d41c8041d7a3835816f5146f3
		writer = csv.writer(csvfile, delimiter=',')
		for tld in tlds:
			with open(results['DNS']+'resultdot'+tld+'.csv', 'r') as DNS_file:
				with open(results['DNSSec']+'resultdot'+tld+'.csv', 'r') as DNSSec_file:
					with open(results['DoT']+'resultdot'+tld+'.csv', 'r') as DoT_file:
						with open(results['DoH']+'resultdot'+tld+'.csv', 'r') as DoH_file:
							dns_rows =[r for r in csv.reader(DNS_file)]
							dnssec_rows = [r for r in csv.reader(DNSSec_file)]
							doh_rows = [r for r in csv.reader(DoH_file)]
							dot_rows = [r for r in csv.reader(DoT_file)]
							writer.writerow([tld])
							for x in range(0,len(dns_rows)):
								
								writer.writerow(
									[
										dns_rows[x][0],dns_rows[x][1],dns_rows[x][2],dns_rows[x][3],' ',
										dnssec_rows[x][1],dnssec_rows[x][2],dnssec_rows[x][3],' ',
										dot_rows[x][1],dot_rows[x][2],dot_rows[x][3],' ',
										doh_rows[x][1],doh_rows[x][2],doh_rows[x][3],' ',
									]
								)

def process_csv(path):
	with open(path, 'r') as file:
		reader = csv.reader(file)
		resolvers = []
		min_list = []
		avg_list = []
		max_list = []
		for line in reader:
			 resolvers.append(line[0])#.split(' ', 1)[1])
			 min_list.append(float(line[1]))
			 avg_list.append(float(line[2]))
			 max_list.append(float(line[3]))

	return resolvers,min_list,avg_list,max_list


def is_tool(name):
    """Check whether `name` is on PATH."""
    from distutils.spawn import find_executable
    return find_executable(name) is not None


def check_install_dependecies():
	"""
	"This part was about to install all tools etc. but I don't feel like writing os specific versions. 
	"""
	#DNSPerf
	if is_tool('dnsperf'):
		pass
	if is_tool('dig'):
		pass
	if is_tool('flame'):
		pass

def call_all_the_scripts():
	#DNSnormal
	os.chdir('../NormalDNS/')
	subprocess.call(['bash','clean.sh'])
	subprocess.call(['bash','./dns_resolver.sh', '../dns_resolvers.txt','../LiveDomains/'])
	# #DNSSec
	os.chdir('../DNSSEC/')
	subprocess.call(['bash','clean.sh'])
	subprocess.call(['bash','dnssec.sh'])
	# #DoT
	os.chdir('../DoT/')
	subprocess.call(['bash','clean.sh'])
	subprocess.call(['bash','./DoT.sh', '../dns_resolvers.txt','../LiveDomains/']) # Change  the second argument so that it works
	# #DoH
	os.chdir('../DoH/')
	subprocess.call(['bash','clean.sh'])
	subprocess.call(['bash','doh.sh'])
	os.chdir('../Plot/')

	

def autolabel(rects, xpos='center'):
    """
    Attach a text label above each bar in *rects*, displaying its height.

    *xpos* indicates which side to place the text w.r.t. the center of
    the bar. It can be one of the following {'center', 'right', 'left'}.
    """

    ha = {'center': 'center', 'right': 'left', 'left': 'right'}
    offset = {'center': 0, 'right': 1, 'left': -1}

    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 3, height),
                    xytext=(offset[xpos]*3, 3),  # use 3 points offset
                    textcoords="offset points",  # in both directions
                    ha=ha[xpos], va='bottom')

if __name__ == "__main__":
	
	DNS_path = "../NormalDNS/"
	DNSSec_path = "../DNSSEC/"
	DoT_path = "../DoT/"
	DoH_path = "../DoH/"

	#print_MOD()

	call_all_the_scripts()


	TLDS=["com", "net", "au", "nl", "ca"]
	for tld in TLDS:
		process_txt(DNSSec_path+"Results/resultdot"+tld+".txt", DNSSec_path+"Results/resultdot"+tld+".csv",False)
	  	process_txt(DoH_path+"Results/resultdot"+tld+".txt", DoH_path+"Results/resultdot"+tld+".csv")    
	
	combain_all_csv(TLDS,2)
	subprocess.call(['bash','complete.sh'])

	# r, minlist, avglist, maxlist = process_csv(DNS_path+'Results/resultdotbr.csv')
	# rT = tuple(r)
	# minT = tuple(minlist)
	# avgT = tuple(avglist)
	# maxT = tuple(maxlist)

	# ind = np.arange(len(avgT))  # the x locations for the groups
	# width = 0.3  # the width of the bars

	# fig, ax = plt.subplots()
	# rects1 = ax.bar(ind - width/3, minT, width/3, label='Min')
	# rects2 = ax.bar(ind, avgT, width/3, label='Avg')
	# rects3 = ax.bar(ind + width/3, maxT, width/3, label='Max')
	
	# ax.set_ylabel('Times')
	# ax.set_title('Times for Regular DNS dotbr')
	# ax.set_xticks(ind)
	# ax.set_ylim(bottom=0)
	# ax.set_xticklabels(rT)
	# ax.legend()

	# autolabel(rects1, "left")
	# autolabel(rects2, "center")
	# autolabel(rects3, "right")

	# fig.tight_layout()

	# plt.show()
	#plt.savefig('figure.png')

