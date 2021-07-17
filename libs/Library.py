from robot.api import logger
import logging as plogger
import pandas
import requests

plogger.basicConfig(
    filename='log.log', 
    format='%(asctime)s - %(message)s', 
    datefmt='%d-%m-%y %H:%M:%S', 
    force=True
)

class Library:

    
    def __init__(self) -> None:
        super().__init__()
        self.api_token = ''
    
    def set_api_token(self, token: str) -> None:
        self.api_token = token
        self.write_log(f'Library: api_token: {self.api_token}', plogger.DEBUG)


    def get_clan(self, name: str, tag: str) -> str:
        """
        Busca clan pelo nome e filtra pelo inicio da tag ou ela completa

        arguments:
        name:       nome do clan que será buscado
        tag:        tag do clan para filtrar entre os clans com o mesmo nome

        return:
        clan:       dicionário com os dados do clan que atender as condições
                    caso nenhum clan atenda os filtros, irá retornar None
        """
        try:
            self.write_log(f'Library: buscando clans de nome "{name}"')
            response = requests.get(
                f'https://api.clashroyale.com/v1/clans?name={name}',
                headers={'Authorization': f'Bearer {self.api_token}'},
            )
            self.write_log('Library: status request da busca de clans pelo nome: '\
                        f'{response.status_code}', plogger.DEBUG)
            response = response.json()
            clans = response['items']
        except Exception as e:
            self.write_log(f'Library: Erro ao buscar clans, erro: {e}', plogger.ERROR)
            return None
        clan = 'None'
        try:
            self.write_log(f'Library: buscando clan que a tag inicie c/ "{tag}" no Brasil')
            for item in clans:
                if item['tag'].startswith(tag) \
                        and item['location']['isCountry'] is True \
                        and item['location']['countryCode'].upper() == 'BR':
                    clan = item['tag']
                    break
        except Exception as e:
            self.write_log(f'Library: Erro ao buscar tag na lista de clans: {e}', 
                        plogger.ERROR)
        self.write_log(f'Library: tag completa do clan {clan}', plogger.DEBUG)
        return clan

    def get_members(self, clan_tag: str) -> None:
        """
        Busca membros do clan pela clan_tag informada e gera um arquivo CSV com
        informações básicas do jogador.

        arguments:
        clan_tag:   tag do clan
        """
        try:
            self.write_log(f'Library: buscando membros do clan de tag {clan_tag}')
            clan_tag = clan_tag.strip('#')
            response = requests.get(
                f'https://api.clashroyale.com/v1/clans/%23{clan_tag}/members',
                headers={'Authorization': f'Bearer {self.api_token}'},
            )
            self.write_log('Library: status request da busca de membros pela tag '\
                    f'{clan_tag}: {response.status_code}', plogger.DEBUG)
            response = response.json()
            members = response['items']
        except Exception as e:
            self.write_log(f'Library: Erro ao buscar membros do clan: {e}', plogger.ERROR)
            return
        try:
            self.write_log(f'Library: processando dados dos membros para gerar arquivo')
            data = []
            for member in members:
                data.append([
                        member['name'],
                        member['expLevel'],
                        member['trophies'],
                        member['role']
                    ])
            self.write_log(f'Library: total de registros processados: {len(data)}', 
                        plogger.DEBUG)
            cols = ['Nome', 'Level', 'Troféus', 'Papel']
            df = pandas.DataFrame(data, columns=cols)
            df.to_csv(f'membros_do_clan_{clan_tag}.csv', index=False, 
                        encoding='utf-8-sig')
        except Exception as e:
            self.write_log(f'Library: Erro ao processar dados: {e}', plogger.ERROR)
        else:
            self.write_log(f'Library: arquivo membros_do_clan_{clan_tag}.csv gerado.')


    def write_log(self, msg: str, level=plogger.INFO, console=True) -> None:
        """Escreve o log das ações no logging do python e no logger do robot.api"""
        if level == plogger.INFO:
            plogger.info(msg)
            logger.info(msg, also_console=console)
        elif level == plogger.DEBUG:
            logger.debug(msg)
            plogger.debug(msg)
        else:
            logger.error(msg)
            plogger.error(msg)